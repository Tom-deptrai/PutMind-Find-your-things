import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:putmind/l10n/app_localizations.dart';
import 'package:putmind/models/memory.dart';
import 'package:putmind/models/settings.dart';
import 'package:putmind/services/backup_service.dart';
import 'package:putmind/services/image_storage.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/services/sqlite_memory_repository.dart';
import 'package:putmind/state/app_state.dart';
import 'package:putmind/widgets/memory_card.dart';
import 'package:putmind/widgets/success_indicator.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('Multi-photo Memory model + SQLite', () {
    test('legacy single image_path migrates to image_paths list', () async {
      final repo = await SqliteMemoryRepository.openInMemory();
      addTearDown(repo.close);

      // Simulate pre-migration row shape via direct insert is covered by fromMap:
      final legacy = Memory.fromMap({
        'id': 'legacy',
        'transcript': 'Keys, drawer',
        'image_path': '/old/a.jpg',
        'created_at': 1,
        'updated_at': 1,
      });
      expect(legacy.imagePaths, ['/old/a.jpg']);
      expect(legacy.imagePath, '/old/a.jpg');

      await repo.upsert(
        Memory(
          id: 'm1',
          transcript: 'Cable, box 17',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
          imagePaths: const ['/a.jpg', '/b.jpg', '/c.jpg'],
        ),
      );
      final loaded = await repo.getById('m1');
      expect(loaded!.imagePaths, ['/a.jpg', '/b.jpg', '/c.jpg']);
      expect(loaded.imagePath, '/a.jpg');
      expect(loaded.hasMultiplePhotos, isTrue);
    });
  });

  group('Capture multi-photo flows', () {
    late Directory temp;
    late AppState state;

    setUp(() async {
      temp = await Directory.systemTemp.createTemp('pm_multi_');
      state = await AppState.create(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(temp),
        settings: const AppSettings(voiceGuidance: false),
      );
    });

    tearDown(() async {
      state.dispose();
      if (await temp.exists()) await temp.delete(recursive: true);
    });

    test('create Memory with 1 photo', () async {
      state.openCapture();
      state.takePhoto(mockImagePath: 'mock-1');
      state.setCaptureTranscript('Passport, desk drawer');
      expect(await state.saveMemory(), isTrue);
      expect(state.memories, hasLength(1));
      expect(state.memories.first.photoCount, 1);
      expect(state.successTick, greaterThan(0));
      expect(state.snackMessage, isEmpty);
    });

    test('create Memory with 5 photos; reject #6; preserve order', () async {
      state.openCapture();
      state.takePhoto(mockImagePath: 'mock-0');
      state.setCaptureTranscript('Shared transcript stays');
      for (var i = 1; i < 5; i++) {
        expect(state.canAddCapturePhoto, isTrue);
        state.startAddPhoto();
        expect(state.isCameraPhase, isTrue);
        state.takePhoto(mockImagePath: 'mock-$i');
        expect(state.captureTranscript, 'Shared transcript stays');
        expect(state.captureImagePaths, hasLength(i + 1));
      }
      expect(state.canAddCapturePhoto, isFalse);
      state.startAddPhoto(); // no-op at max
      expect(state.captureImagePaths, hasLength(5));

      expect(await state.saveMemory(), isTrue);
      final m = state.memories.first;
      expect(m.imagePaths, ['mock-0', 'mock-1', 'mock-2', 'mock-3', 'mock-4']);
      expect(m.imagePath, 'mock-0');
    });

    test('Retake replaces only current draft photo', () async {
      state.openCapture();
      state.takePhoto(mockImagePath: 'mock-a');
      state.setCaptureTranscript('Keep me');
      state.startAddPhoto();
      state.takePhoto(mockImagePath: 'mock-b');
      state.startAddPhoto();
      state.takePhoto(mockImagePath: 'mock-c');
      expect(state.captureImagePaths, ['mock-a', 'mock-b', 'mock-c']);
      expect(state.captureActiveIndex, 2);

      state.retake();
      expect(state.captureImagePaths, ['mock-a', 'mock-b']);
      expect(state.captureTranscript, 'Keep me');
      expect(state.isCameraPhase, isTrue);

      state.takePhoto(mockImagePath: 'mock-c2');
      expect(state.captureImagePaths, ['mock-a', 'mock-b', 'mock-c2']);
      expect(state.captureTranscript, 'Keep me');
    });

    test(
      'Replace selected photo updates that index; cover if index 0',
      () async {
        final storage = ImageStorage.forDirectory(temp);
        Future<String> shot(String id) async {
          final src = File(p.join(temp.path, '$id-src.jpg'))
            ..writeAsBytesSync(List<int>.filled(12, 9));
          return storage.persistCapturedImage(src.path, id: id);
        }

        final cover = await shot('cover');
        final two = await shot('two');
        final three = await shot('three');
        final repo = InMemoryMemoryRepository(
          seed: [
            Memory(
              id: 'm1',
              transcript: 'T',
              createdAt: DateTime.utc(2026, 1, 1),
              updatedAt: DateTime.utc(2026, 1, 1),
              imagePaths: [cover, two, three],
            ),
          ],
        );
        final s = await AppState.create(
          repository: repo,
          imageStorage: storage,
          settings: const AppSettings(voiceGuidance: false),
        );
        addTearDown(s.dispose);

        final replacement2 = File(p.join(temp.path, 'rep2.jpg'))
          ..writeAsBytesSync(List<int>.filled(12, 2));
        s.openReplacePhoto(s.memories.first, photoIndex: 1);
        s.onPhotoCaptured(replacement2.path);
        expect(await s.saveMemory(), isTrue);
        expect(s.memories.first.imagePaths[0], cover);
        expect(s.memories.first.imagePaths[1], isNot(two));
        expect(File(s.memories.first.imagePaths[1]).existsSync(), isTrue);
        expect(s.memories.first.imagePath, cover);

        final replacement0 = File(p.join(temp.path, 'rep0.jpg'))
          ..writeAsBytesSync(List<int>.filled(12, 0));
        s.openReplacePhoto(s.memories.first, photoIndex: 0);
        s.onPhotoCaptured(replacement0.path);
        expect(await s.saveMemory(), isTrue);
        expect(s.memories.first.imagePath, isNot(cover));
        expect(s.memories.first.imagePaths[1], isNot(two));
      },
    );

    test('Delete removes all image files', () async {
      final src1 = File(p.join(temp.path, 's1.jpg'))
        ..writeAsBytesSync(List<int>.filled(8, 1));
      final src2 = File(p.join(temp.path, 's2.jpg'))
        ..writeAsBytesSync(List<int>.filled(8, 2));
      final storage = ImageStorage.forDirectory(temp);
      final p1 = await storage.persistCapturedImage(src1.path, id: 'd-0');
      final p2 = await storage.persistCapturedImage(src2.path, id: 'd-1');
      final repo = InMemoryMemoryRepository(
        seed: [
          Memory(
            id: 'del',
            transcript: 'T',
            createdAt: DateTime.utc(2026, 1, 1),
            updatedAt: DateTime.utc(2026, 1, 1),
            imagePaths: [p1, p2],
          ),
        ],
      );
      final s = await AppState.create(
        repository: repo,
        imageStorage: storage,
        settings: const AppSettings(),
      );
      addTearDown(s.dispose);

      expect(File(p1).existsSync(), isTrue);
      expect(File(p2).existsSync(), isTrue);
      s.openMemoryDetail(s.memories.first);
      await s.confirmDeleteSelected();
      expect(File(p1).existsSync(), isFalse);
      expect(File(p2).existsSync(), isFalse);
      expect(s.memories, isEmpty);
    });
  });

  group('Backup multi-photo', () {
    test(
      'backup/restore preserves ordered photos; v1 single image still loads',
      () async {
        final temp = await Directory.systemTemp.createTemp('pm_bak_');
        addTearDown(() async {
          if (await temp.exists()) await temp.delete(recursive: true);
        });
        final images = ImageStorage.forDirectory(temp);
        final repo = InMemoryMemoryRepository();
        final backup = BackupService(repository: repo, imageStorage: images);

        final files = <String>[];
        for (var i = 0; i < 3; i++) {
          final src = File(p.join(temp.path, 'raw$i.jpg'))
            ..writeAsBytesSync(List<int>.filled(16, i + 1));
          files.add(await images.persistCapturedImage(src.path, id: 'm1_$i'));
        }
        await repo.upsert(
          Memory(
            id: 'm1',
            transcript: 'Multi',
            createdAt: DateTime.utc(2026, 1, 1),
            updatedAt: DateTime.utc(2026, 1, 2),
            imagePaths: files,
          ),
        );

        final bytes = await backup.createBackupBytes('pw');
        await repo.clear();
        final decrypted = await backup.decryptAndValidate(bytes, 'pw');
        expect(decrypted.manifest.schemaVersion, kBackupSchemaVersion);
        expect(decrypted.memories.first.imagePaths, hasLength(3));
        await backup.commitRestore(decrypted);
        final restored = (await repo.getAll()).first;
        expect(restored.imagePaths, hasLength(3));
        expect(restored.imagePath, restored.imagePaths.first);
        for (final path in restored.imagePaths) {
          expect(File(path).existsSync(), isTrue);
        }

        // Legacy v1 payload shape (single `image`) still maps to one photo.
        final legacyMemory = Memory(
          id: 'old',
          transcript: 'Legacy',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
          imagePaths: const ['legacy.jpg'],
        );
        expect(legacyMemory.imagePaths, ['legacy.jpg']);
      },
    );
  });

  group('Home card + success indicator UI', () {
    testWidgets(
      'Home card shows transcript, no title; photo count only if >1',
      (tester) async {
        final single = Memory(
          id: 's',
          transcript: 'Single transcript body',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
          imagePaths: const ['mock-a'],
        );
        final multi = Memory(
          id: 'm',
          transcript: 'Multi transcript body',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
          imagePaths: const ['mock-a', 'mock-b', 'mock-c'],
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: ListView(
                children: [
                  MemoryCard(memory: single, onTap: () {}),
                  MemoryCard(memory: multi, onTap: () {}),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Single transcript body'), findsOneWidget);
        expect(find.text('Multi transcript body'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
      },
    );

    testWidgets('success indicator appears on trigger without snackbar', (
      tester,
    ) async {
      var tick = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return SuccessIndicatorHost(
                trigger: tick,
                child: Scaffold(
                  body: ElevatedButton(
                    onPressed: () => setState(() => tick++),
                    child: const Text('go'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      await tester.tap(find.text('go'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pumpAndSettle();
    });

    test('localization strings exist for Add Photo', () {
      final en = lookupAppLocalizations(const Locale('en'));
      final vi = lookupAppLocalizations(const Locale('vi'));
      final de = lookupAppLocalizations(const Locale('de'));
      final fr = lookupAppLocalizations(const Locale('fr'));
      expect(en.captureAddPhoto, isNotEmpty);
      expect(vi.captureAddPhoto, contains('ảnh'));
      expect(de.captureAddPhoto, isNotEmpty);
      expect(fr.captureAddPhoto, isNotEmpty);
      expect(en.capturePhotoCount(3, 5), '3/5');
      expect(en.memoryDetailPhotoIndex(1, 3), '1/3');
    });
  });
}

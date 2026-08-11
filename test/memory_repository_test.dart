import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:putmind/models/memory.dart';
import 'package:putmind/services/image_storage.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/services/sqlite_memory_repository.dart';
import 'package:putmind/state/app_state.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SqliteMemoryRepository', () {
    late SqliteMemoryRepository repo;

    setUp(() async {
      repo = await SqliteMemoryRepository.openInMemory();
    });

    tearDown(() async {
      await repo.close();
    });

    test('create, list newest-first, read, update, delete', () async {
      final older = Memory(
        id: 'a',
        transcript: 'Passport, in the desk drawer.',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
        imagePath: '/tmp/a.jpg',
      );
      final newer = Memory(
        id: 'b',
        transcript: 'Keys, in the kitchen bowl.',
        createdAt: DateTime(2026, 2, 1),
        updatedAt: DateTime(2026, 2, 1),
        imagePath: '/tmp/b.jpg',
      );

      await repo.upsert(older);
      await repo.upsert(newer);

      final all = await repo.getAll();
      expect(all.map((m) => m.id), ['b', 'a']);

      final fetched = await repo.getById('a');
      expect(fetched?.transcript, contains('Passport'));

      final updated = older.copyWith(
        transcript: 'Passport, in the travel pouch.',
        updatedAt: DateTime(2026, 3, 1),
      );
      await repo.upsert(updated);
      expect((await repo.getById('a'))?.transcript, contains('travel pouch'));

      await repo.delete('a');
      expect(await repo.getById('a'), isNull);
      expect(await repo.getAll(), hasLength(1));
    });

    test('search is case-insensitive partial match with relevance', () async {
      await repo.upsert(
        Memory(
          id: '1',
          transcript: 'Sony camera cable, in box 17.',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      );
      await repo.upsert(
        Memory(
          id: '2',
          transcript: 'Passport, in the second drawer.',
          createdAt: DateTime(2026, 2, 1),
          updatedAt: DateTime(2026, 2, 1),
        ),
      );

      final results = await repo.search('sony');
      expect(results, hasLength(1));
      expect(results.first.id, '1');

      final passport = await repo.search('PASS');
      expect(passport, isNotEmpty);
      expect(passport.first.transcript.toLowerCase(), contains('passport'));
    });
  });

  group('ImageStorage', () {
    test('persist and delete managed images', () async {
      final dir = await Directory.systemTemp.createTemp('putmind_images_');
      addTearDown(() async {
        if (await dir.exists()) await dir.delete(recursive: true);
      });

      final storage = ImageStorage.forDirectory(dir);
      final source = File(p.join(dir.path, 'source.jpg'));
      await source.writeAsBytes(List<int>.filled(16, 7));

      final saved = await storage.persistCapturedImage(
        source.path,
        id: 'mem-1',
      );
      expect(File(saved).existsSync(), isTrue);
      expect(saved.contains(dir.path), isTrue);

      await storage.deleteImage(saved);
      expect(File(saved).existsSync(), isFalse);
    });
  });

  group('AppState persistence flows', () {
    Future<AppState> buildState({List<Memory>? seed}) async {
      final repo = InMemoryMemoryRepository(seed: seed);
      final dir = await Directory.systemTemp.createTemp('putmind_state_');
      addTearDown(() async {
        if (await dir.exists()) await dir.delete(recursive: true);
      });
      return AppState.create(
        repository: repo,
        imageStorage: ImageStorage.forDirectory(dir),
      );
    }

    test('starts empty without seed and save adds memory', () async {
      final state = await buildState();
      expect(state.memories, isEmpty);

      state.openCapture();
      state.takePhoto(mockImagePath: 'mock-captured');
      state.setCaptureTranscript('Spare keys, in the kitchen drawer.');
      final saved = await state.saveMemory();

      expect(saved, isTrue);
      expect(state.route, AppRoute.home);
      expect(state.memories, hasLength(1));
      expect(state.memories.first.transcript, contains('Spare keys'));
    });

    test('search filters memories via repository', () async {
      final state = await buildState(seed: createSeedMemories());
      await state.setSearchQuery('passport');
      expect(state.filteredMemories, hasLength(1));
      expect(state.filteredMemories.first.title, 'Passport');
    });

    test('paywall blocks memory 21 for free users', () async {
      final seed = List.generate(
        20,
        (i) => createSeedMemories().first.copyWith(
          id: 'm-$i',
          transcript: 'Item $i, location $i',
        ),
      );
      final state = await buildState(seed: seed);
      expect(state.memoryCount, 20);
      expect(state.canAddMemory, isFalse);

      state.openCapture();
      state.takePhoto(mockImagePath: 'mock-captured');
      state.setCaptureTranscript('Too many, in a box.');
      final saved = await state.saveMemory();

      expect(saved, isFalse);
      expect(state.showPaywall, isTrue);
      expect(state.memoryCount, 20);
    });

    test('delete removes memory', () async {
      final state = await buildState(seed: createSeedMemories());
      final first = state.memories.first;
      state.openMemoryDetail(first);
      await state.confirmDeleteSelected();
      expect(state.memories.any((m) => m.id == first.id), isFalse);
    });

    test('update transcript persists', () async {
      final state = await buildState(seed: createSeedMemories());
      final first = state.memories.first;
      state.openMemoryDetail(first);
      await state.updateSelectedTranscript('Updated passport location.');
      expect(state.memories.first.transcript, 'Updated passport location.');
    });
  });
}

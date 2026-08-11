import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:putmind/models/memory.dart';
import 'package:putmind/models/settings.dart';
import 'package:putmind/services/backup_service.dart';
import 'package:putmind/services/image_storage.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/services/purchase_service.dart';
import 'package:putmind/services/voice_guidance_player.dart';
import 'package:putmind/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Voice guidance assets', () {
    test('scripts.json covers all 10 locales', () {
      final file = File('assets/voice_guidance/scripts.json');
      expect(file.existsSync(), isTrue);
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final locales = (json['locales'] as Map).keys.toSet();
      final expected = AppLanguage.values
          .map((e) => e.voiceGuidanceLocale)
          .toSet();
      expect(locales, expected);
      expect(json['productionReady'], isTrue);
    });

    test('asset mapping exists for every AppLanguage', () {
      for (final lang in AppLanguage.values) {
        final path = VoiceGuidancePlayer.assetPathFor(lang);
        expect(File(path).existsSync(), isTrue, reason: path);
      }
    });

    test('all 10 production assets are non-silence and non-trivial', () {
      for (final lang in AppLanguage.values) {
        final file = File(VoiceGuidancePlayer.assetPathFor(lang));
        final len = file.lengthSync();
        expect(len, greaterThan(0), reason: lang.voiceGuidanceLocale);
        expect(
          len,
          isNot(kVoiceSilencePlaceholderBytes),
          reason: '${lang.voiceGuidanceLocale} still silence placeholder',
        );
        expect(
          len,
          greaterThan(20000),
          reason: '${lang.voiceGuidanceLocale} unexpectedly small',
        );
      }
    });

    test('no Google Cloud voice generator remains in tool/', () {
      expect(
        File('tool/generate_voice_guidance.py').existsSync(),
        isFalse,
        reason: 'cloud TTS generator must stay removed',
      );
      expect(
        File('tool/generate_voice_guidance_offline.py').existsSync(),
        isTrue,
      );
      final scripts = File(
        'assets/voice_guidance/scripts.json',
      ).readAsStringSync();
      expect(scripts.toLowerCase().contains('neural2'), isFalse);
      expect(scripts.toLowerCase().contains('wavenet'), isFalse);
      final licenseReadme = File(
        'docs/voice_guidance_license/README.md',
      ).readAsStringSync().toLowerCase();
      expect(licenseReadme.contains('google cloud text-to-speech'), isFalse);
      expect(licenseReadme.contains('application_credentials'), isFalse);
      expect(licenseReadme.contains('neural2'), isFalse);
    });

    test('playback failure still proceeds to speech listening', () async {
      final images = ImageStorage.forDirectory(
        Directory.systemTemp.createTempSync('pm_voice_fail_'),
      );
      final state = AppState(
        repository: InMemoryMemoryRepository(),
        imageStorage: images,
        purchaseService: FakePurchaseService(),
        voiceGuidancePlayer: _ThrowingVoiceGuidancePlayer(),
        settings: const AppSettings(
          onboardingCompleted: true,
          voiceGuidance: true,
          language: AppLanguage.vietnamese,
        ),
      );
      state.takePhoto(mockImagePath: 'mock-captured');
      expect(state.capturePhase, CapturePhase.guiding);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(state.capturePhase, CapturePhase.listening);
      await Future<void>.delayed(const Duration(milliseconds: 500));
      expect(state.capturePhase, CapturePhase.editing);
    });

    test('language switch uses matching voice locale mapping', () {
      expect(AppLanguage.vietnamese.voiceGuidanceLocale, 'vi-VN');
      expect(AppLanguage.english.voiceGuidanceLocale, 'en-US');
      expect(AppLanguage.japanese.voiceGuidanceLocale, 'ja-JP');
      expect(AppLanguage.korean.voiceGuidanceLocale, 'ko-KR');
      expect(AppLanguage.traditionalChineseHant.voiceGuidanceLocale, 'zh-TW');
      for (final lang in AppLanguage.values) {
        expect(
          VoiceGuidancePlayer.assetPathFor(lang),
          'assets/voice_guidance/${lang.voiceGuidanceLocale}.wav',
        );
      }
    });
  });

  group('BackupService', () {
    late Directory temp;
    late InMemoryMemoryRepository repo;
    late ImageStorage images;
    late BackupService backup;

    setUp(() async {
      temp = await Directory.systemTemp.createTemp('putmind_backup_test_');
      final imgDir = Directory(p.join(temp.path, 'images'))..createSync();
      images = ImageStorage.forDirectory(imgDir);
      repo = InMemoryMemoryRepository();
      backup = BackupService(repository: repo, imageStorage: images);
    });

    tearDown(() async {
      if (await temp.exists()) {
        await temp.delete(recursive: true);
      }
    });

    Future<Memory> seedWithPhoto() async {
      final src = File(p.join(temp.path, 'shot.jpg'));
      await src.writeAsBytes(List<int>.generate(64, (i) => i));
      final path = await images.persistCapturedImage(src.path, id: 'm1');
      final memory = Memory(
        id: 'm1',
        transcript: 'Keys, in the kitchen drawer.',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 2),
        imagePath: path,
      );
      await repo.upsert(memory);
      return memory;
    }

    test(
      'create + decrypt with correct password restores memories and photos',
      () async {
        await seedWithPhoto();
        final bytes = await backup.createBackupBytes('secret-pass');
        expect(bytes.take(4), utf8.encode('PMBK'));

        await repo.clear();
        expect(await repo.getAll(), isEmpty);

        final decrypted = await backup.decryptAndValidate(bytes, 'secret-pass');
        expect(decrypted.memories, hasLength(1));
        expect(decrypted.imageBytesByName, isNotEmpty);

        await backup.commitRestore(decrypted);
        final all = await repo.getAll();
        expect(all, hasLength(1));
        expect(all.first.transcript, contains('Keys'));
        expect(all.first.imagePath, isNotNull);
        expect(File(all.first.imagePath!).existsSync(), isTrue);
      },
    );

    test('wrong password fails without changing data', () async {
      await seedWithPhoto();
      final before = await repo.getAll();
      final bytes = await backup.createBackupBytes('correct-password');
      expect(
        () => backup.decryptAndValidate(bytes, 'wrong-password'),
        throwsA(
          isA<BackupException>().having(
            (e) => e.reason,
            'reason',
            BackupFailureReason.wrongPassword,
          ),
        ),
      );
      expect(await repo.getAll(), before);
    });

    test('corrupted file fails safely', () async {
      await seedWithPhoto();
      final bytes = await backup.createBackupBytes('pw1234');
      bytes[20] ^= 0xff;
      expect(
        () => backup.decryptAndValidate(bytes, 'pw1234'),
        throwsA(isA<BackupException>()),
      );
      expect(await repo.getAll(), hasLength(1));
    });

    test('unsupported format version is rejected', () async {
      final bog = BytesBuilder();
      bog.add(utf8.encode('PMBK'));
      bog.add((ByteData(4)..setUint32(0, 99, Endian.big)).buffer.asUint8List());
      bog.add(
        (ByteData(4)..setUint32(0, 1000, Endian.big)).buffer.asUint8List(),
      );
      bog.add((ByteData(2)..setUint16(0, 1, Endian.big)).buffer.asUint8List());
      bog.add([0]); // salt
      bog.add((ByteData(2)..setUint16(0, 1, Endian.big)).buffer.asUint8List());
      bog.add([0]); // nonce
      bog.add((ByteData(4)..setUint32(0, 0, Endian.big)).buffer.asUint8List());
      expect(
        () => backup.decryptAndValidate(bog.toBytes(), 'x'),
        throwsA(
          isA<BackupException>().having(
            (e) => e.reason,
            'reason',
            BackupFailureReason.unsupportedVersion,
          ),
        ),
      );
    });

    test('failed restore keeps existing data', () async {
      await seedWithPhoto();
      final existing = await repo.getAll();
      final bytes = await backup.createBackupBytes('pw1234');
      // Decrypt OK then force commit with broken image staging by emptying map after hack:
      final decrypted = await backup.decryptAndValidate(bytes, 'pw1234');
      // Corrupt by clearing repository mid-flight is covered by replaceAll rollback:
      // Simulate commit on empty images still OK; instead throw via replaceAll spy.
      final flaky = _FlakyRepo(seed: existing, failReplace: true);
      final flakyBackup = BackupService(
        repository: flaky,
        imageStorage: images,
      );
      expect(
        () => flakyBackup.commitRestore(decrypted),
        throwsA(isA<BackupException>()),
      );
      expect(await flaky.getAll(), existing);
    });
  });

  group('Monetization', () {
    test(
      'free users can create through memory #20; #21 opens paywall',
      () async {
        final repo = InMemoryMemoryRepository();
        final images = ImageStorage.forDirectory(
          Directory.systemTemp.createTempSync('pm_mon_'),
        );
        final purchase = FakePurchaseService();
        final state = AppState(
          repository: repo,
          imageStorage: images,
          purchaseService: purchase,
          settings: const AppSettings(onboardingCompleted: true),
        );
        await purchase.initialize();

        for (var i = 0; i < kFreeMemoryLimit; i++) {
          await repo.upsert(
            Memory(
              id: 'id-$i',
              transcript: 'Item $i',
              createdAt: DateTime.utc(2026, 1, 1),
              updatedAt: DateTime.utc(2026, 1, 1),
            ),
          );
        }
        await state.reloadMemories();
        expect(state.canAddMemory, isFalse);
        expect(state.memoryCount, kFreeMemoryLimit);

        state.openPaywall();
        expect(state.showPaywall, isTrue);

        await repo.delete('id-0');
        await state.reloadMemories();
        expect(state.canAddMemory, isTrue);

        await state.grantLifetimeEntitlement();
        expect(state.settings.isLifetimeUnlocked, isTrue);
        expect(state.canAddMemory, isTrue);
      },
    );

    test('purchase success unlocks lifetime', () async {
      final purchase = FakePurchaseService(buyResult: PurchasePhase.success);
      final state = AppState(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(
          Directory.systemTemp.createTempSync('pm_buy_'),
        ),
        purchaseService: purchase,
        settings: const AppSettings(onboardingCompleted: true),
      );
      await purchase.initialize();
      final phase = await state.purchaseLifetime();
      expect(phase, PurchasePhase.success);
      expect(state.settings.isLifetimeUnlocked, isTrue);
    });

    test('restore none does not unlock', () async {
      final purchase = FakePurchaseService(
        restoreResult: PurchasePhase.restoreNone,
      );
      final state = AppState(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(
          Directory.systemTemp.createTempSync('pm_res_'),
        ),
        purchaseService: purchase,
        settings: const AppSettings(onboardingCompleted: true),
      );
      await purchase.initialize();
      final phase = await state.restorePurchases();
      expect(phase, PurchasePhase.restoreNone);
      expect(state.settings.isLifetimeUnlocked, isFalse);
    });
  });
}

class _ThrowingVoiceGuidancePlayer extends VoiceGuidancePlayer {
  @override
  Future<void> play(AppLanguage language) async {
    throw StateError('simulated playback failure');
  }
}

class _FlakyRepo implements MemoryRepository {
  _FlakyRepo({required List<Memory> seed, required this.failReplace})
    : _memories = [...seed];

  final List<Memory> _memories;
  final bool failReplace;
  var _replaceAttempts = 0;

  @override
  Future<List<Memory>> getAll() async => List.unmodifiable(_memories);

  @override
  Future<Memory?> getById(String id) async {
    for (final m in _memories) {
      if (m.id == id) return m;
    }
    return null;
  }

  @override
  Future<void> upsert(Memory memory) async {
    final i = _memories.indexWhere((m) => m.id == memory.id);
    if (i >= 0) {
      _memories[i] = memory;
    } else {
      _memories.add(memory);
    }
  }

  @override
  Future<void> delete(String id) async =>
      _memories.removeWhere((m) => m.id == id);

  @override
  Future<List<Memory>> search(String query) async => getAll();

  @override
  Future<void> replaceAll(List<Memory> memories) async {
    _replaceAttempts++;
    if (failReplace && _replaceAttempts == 1) {
      throw StateError('replace failed');
    }
    _memories
      ..clear()
      ..addAll(memories);
  }

  @override
  Future<void> clear() async => _memories.clear();

  @override
  Future<void> close() async {}
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:putmind/models/settings.dart';
import 'package:putmind/services/image_storage.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/services/pin_store.dart';
import 'package:putmind/services/settings_store.dart';
import 'package:putmind/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

Directory _temp(String name) {
  final dir = Directory.systemTemp.createTempSync('putmind_$name');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  return dir;
}

Future<AppState> _state({
  AppSettings? settings,
  SettingsStore? store,
  PinStore? pinStore,
}) async {
  SharedPreferences.setMockInitialValues({});
  final dir = _temp('step3');
  return AppState.create(
    repository: InMemoryMemoryRepository(seed: createSeedMemories()),
    imageStorage: ImageStorage.forDirectory(dir),
    settingsStore: store ?? SettingsStore(),
    pinStore: pinStore ?? PinStore(),
    settings: settings,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Settings persistence', () {
    test('round-trips language and toggles through SettingsStore', () async {
      SharedPreferences.setMockInitialValues({});
      final store = SettingsStore();
      final original = const AppSettings(
        language: AppLanguage.vietnamese,
        voiceGuidance: false,
        dailyReminder: true,
        reminderHour: 20,
        reminderMinute: 30,
        appLock: true,
        autoLock: AutoLockInterval.fiveMinutes,
        onboardingCompleted: true,
      );
      await store.save(original);
      final loaded = await store.load();
      expect(loaded.language, AppLanguage.vietnamese);
      expect(loaded.voiceGuidance, isFalse);
      expect(loaded.dailyReminder, isTrue);
      expect(loaded.reminderHour, 20);
      expect(loaded.reminderMinute, 30);
      expect(loaded.appLock, isTrue);
      expect(loaded.autoLock, AutoLockInterval.fiveMinutes);
    });

    test('AppState persists voice guidance across recreate', () async {
      SharedPreferences.setMockInitialValues({});
      final store = SettingsStore();
      final first = await _state(store: store);
      await first.setVoiceGuidance(false);
      await first.setLanguage(AppLanguage.japanese);

      final second = await AppState.create(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(_temp('step3b')),
        settingsStore: store,
      );
      expect(second.settings.voiceGuidance, isFalse);
      expect(second.settings.language, AppLanguage.japanese);
    });
  });

  group('Locale mapping', () {
    test('speech and voice locales match MVP tags', () {
      expect(AppLanguage.english.speechToTextLocale, 'en-US');
      expect(AppLanguage.vietnamese.voiceGuidanceLocale, 'vi-VN');
      expect(AppLanguage.traditionalChineseHant.speechToTextLocale, 'zh-TW');
      expect(AppLanguage.portugueseBrazil.speechToTextLocale, 'pt-BR');
    });
  });

  group('PIN store', () {
    test('stores hashed pin and verifies correctly', () async {
      final pin = PinStore();
      await pin.clear();
      expect(await pin.hasPin(), isFalse);
      await pin.setPin('2468');
      expect(await pin.hasPin(), isTrue);
      expect(await pin.verifyPin('2468'), isTrue);
      expect(await pin.verifyPin('0000'), isFalse);
    });
  });

  group('App Lock / auto-lock', () {
    test('lockNow routes to unlock when app lock enabled', () async {
      final pin = PinStore();
      await pin.setPin('1357');
      final state = await _state(
        settings: const AppSettings(appLock: true),
        pinStore: pin,
      );
      // Start unlocked for this test
      state.unlockWithBiometrics; // ignore — need finish unlock without bio
      // Force unlocked home then lock
      await state.appendPinDigit('1');
      await state.appendPinDigit('3');
      await state.appendPinDigit('5');
      await state.appendPinDigit('7');
      expect(state.isLocked, isFalse);
      expect(state.route, AppRoute.home);

      state.lockNow();
      expect(state.isLocked, isTrue);
      expect(state.route, AppRoute.unlock);
    });

    test('auto-lock after pause respects interval', () async {
      final pin = PinStore();
      await pin.setPin('1357');
      final state = await _state(
        settings: const AppSettings(
          appLock: true,
          autoLock: AutoLockInterval.oneMinute,
        ),
        pinStore: pin,
      );
      await state.appendPinDigit('1');
      await state.appendPinDigit('3');
      await state.appendPinDigit('5');
      await state.appendPinDigit('7');
      expect(state.isLocked, isFalse);

      state.onAppPaused();
      // Simulate short background — should not lock
      await Future<void>.delayed(const Duration(milliseconds: 20));
      state.onAppResumed();
      expect(state.isLocked, isFalse);

      // Immediately interval locks on any pause duration >= 0
      await state.setAutoLock(AutoLockInterval.immediately);
      state.onAppPaused();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      state.onAppResumed();
      expect(state.isLocked, isTrue);
      expect(state.route, AppRoute.unlock);
    });
  });

  group('Voice guidance state', () {
    test('shared toggle updates settings', () async {
      final state = await _state();
      expect(state.settings.voiceGuidance, isTrue);
      await state.setVoiceGuidance(false);
      expect(state.settings.voiceGuidance, isFalse);
    });
  });
}

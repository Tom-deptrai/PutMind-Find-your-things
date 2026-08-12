import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:putmind/l10n/app_localizations.dart';
import 'package:putmind/models/settings.dart';
import 'package:putmind/screens/unlock_screen.dart';
import 'package:putmind/services/biometric_auth.dart';
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

Future<AppState> _createLockedState({
  required BiometricAuth biometric,
  String pin = '1357',
}) async {
  SharedPreferences.setMockInitialValues({});
  final pinStore = PinStore();
  await pinStore.setPin(pin);
  return AppState.create(
    repository: InMemoryMemoryRepository(),
    imageStorage: ImageStorage.forDirectory(_temp('bio')),
    settingsStore: SettingsStore(),
    pinStore: pinStore,
    biometricAuth: biometric,
    settings: const AppSettings(appLock: true, onboardingCompleted: true),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Biometric cold start', () {
    test('App Lock ON + cold create refreshes biometric capability', () async {
      final state = await _createLockedState(
        biometric: BiometricAuth.fake(available: true),
      );
      expect(state.route, AppRoute.unlock);
      expect(state.isLocked, isTrue);
      expect(state.biometricCapabilityResolved, isTrue);
      expect(state.biometricAvailable, isTrue);
    });

    test('recreate AppState keeps biometric available after refresh', () async {
      final store = SettingsStore();
      SharedPreferences.setMockInitialValues({});
      final pin = PinStore();
      await pin.setPin('2468');
      await store.save(
        const AppSettings(appLock: true, onboardingCompleted: true),
      );

      final first = await AppState.create(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(_temp('bio1')),
        settingsStore: store,
        pinStore: pin,
        biometricAuth: BiometricAuth.fake(available: true),
      );
      expect(first.biometricAvailable, isTrue);

      final second = await AppState.create(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(_temp('bio2')),
        settingsStore: store,
        pinStore: pin,
        biometricAuth: BiometricAuth.fake(available: true),
      );
      expect(second.route, AppRoute.unlock);
      expect(second.biometricCapabilityResolved, isTrue);
      expect(second.biometricAvailable, isTrue);
    });

    test('true unavailable keeps PIN fallback path', () async {
      final state = await _createLockedState(
        biometric: BiometricAuth.fake(available: false),
      );
      expect(state.biometricCapabilityResolved, isTrue);
      expect(state.biometricAvailable, isFalse);

      state.showPinEntry();
      expect(state.showPinFallback, isTrue);
      await state.appendPinDigit('1');
      await state.appendPinDigit('3');
      await state.appendPinDigit('5');
      await state.appendPinDigit('7');
      expect(state.isLocked, isFalse);
      expect(state.route, AppRoute.home);
    });

    test('successful biometric auth unlocks to Home', () async {
      final state = await _createLockedState(
        biometric: BiometricAuth.fake(available: true, authSucceeds: true),
      );
      await state.unlockWithBiometrics();
      expect(state.isLocked, isFalse);
      expect(state.route, AppRoute.home);
    });

    test('failed/cancelled biometric stays on Unlock', () async {
      final state = await _createLockedState(
        biometric: BiometricAuth.fake(available: true, authSucceeds: false),
      );
      await state.unlockWithBiometrics();
      expect(state.isLocked, isTrue);
      expect(state.route, AppRoute.unlock);
      expect(state.snackMessage, 'biometricFailed');
    });

    test('resume while locked refreshes biometric capability', () async {
      final bio = BiometricAuth.fake(available: false);
      final state = await _createLockedState(biometric: bio);
      expect(state.biometricAvailable, isFalse);

      bio.debugSetAvailable(true);
      state.onAppResumed();
      await Future<void>.delayed(Duration.zero);
      expect(state.biometricCapabilityResolved, isTrue);
      expect(state.biometricAvailable, isTrue);
      expect(state.isLocked, isTrue);
      expect(state.route, AppRoute.unlock);
    });

    testWidgets(
      'Unlock does not flash unavailable before capability resolves',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final pin = PinStore();
        await pin.setPin('1357');
        final state = await AppState.create(
          repository: InMemoryMemoryRepository(),
          imageStorage: ImageStorage.forDirectory(_temp('bio_ui')),
          pinStore: pin,
          biometricAuth: BiometricAuth.fake(available: true),
          settings: const AppSettings(appLock: true, onboardingCompleted: true),
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: UnlockScreen(state: state),
          ),
        );
        await tester.pump();

        expect(
          find.text('Biometrics aren’t available. Use your PIN to unlock.'),
          findsNothing,
        );
        expect(find.text('Unlock with biometrics'), findsOneWidget);
      },
    );

    testWidgets('Unlock shows unavailable only after resolved false', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final pin = PinStore();
      await pin.setPin('1357');
      final state = await AppState.create(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(_temp('bio_ui2')),
        pinStore: pin,
        biometricAuth: BiometricAuth.fake(available: false),
        settings: const AppSettings(appLock: true, onboardingCompleted: true),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: UnlockScreen(state: state),
        ),
      );
      await tester.pump();

      expect(find.text('Unlock with biometrics'), findsNothing);
      expect(
        find.text('Biometrics aren’t available. Use your PIN to unlock.'),
        findsOneWidget,
      );
      expect(find.text('Use PIN instead'), findsOneWidget);
    });
  });
}

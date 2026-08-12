import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:putmind/l10n/app_localizations.dart';
import 'package:putmind/models/settings.dart';
import 'package:putmind/screens/settings_screen.dart';
import 'package:putmind/services/app_package_info.dart';
import 'package:putmind/services/backup_file_saver.dart';
import 'package:putmind/services/image_storage.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/services/purchase_service.dart';
import 'package:putmind/state/app_state.dart';
import 'package:putmind/widgets/app_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSaver implements BackupFileSaver {
  _FakeSaver({this.result, this.throwOnSave = false});

  String? result;
  bool throwOnSave;
  Uint8List? lastBytes;
  String? lastFileName;
  int saveCalls = 0;

  @override
  Future<String?> saveBackup({
    required String fileName,
    required Uint8List bytes,
  }) async {
    saveCalls++;
    lastFileName = fileName;
    lastBytes = bytes;
    if (throwOnSave) {
      throw StateError('save failed');
    }
    return result;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('defaultBackupFileName', () {
    test('uses PutMindBackup_YYYY-MM-DD_HH-mm.backup', () {
      final name = defaultBackupFileName(DateTime(2026, 8, 12, 14, 5));
      expect(name, 'PutMindBackup_2026-08-12_14-05.backup');
    });
  });

  group('AppState backup lastBackup timing', () {
    late Directory temp;
    late AppState state;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      temp = Directory.systemTemp.createTempSync('pm_bak_');
      state = AppState(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(temp),
        purchaseService: FakePurchaseService(),
        settings: const AppSettings(onboardingCompleted: true),
      );
    });

    tearDown(() {
      if (temp.existsSync()) {
        temp.deleteSync(recursive: true);
      }
    });

    test('exportBackupBytes does not set lastBackupAt', () async {
      final bytes = await state.exportBackupBytes('secret');
      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);
      expect(state.settings.lastBackupAt, isNull);
      expect(state.successTick, 0);
    });

    test('markBackupSaved updates lastBackupAt and success', () async {
      final before = state.successTick;
      await state.markBackupSaved();
      expect(state.settings.lastBackupAt, isNotNull);
      expect(state.successTick, before + 1);
    });

    test('failed save report does not update lastBackupAt', () async {
      state.reportBackupSaveFailed();
      expect(state.settings.lastBackupAt, isNull);
      expect(state.snackMessage, 'snackBackupSaveFailed');
    });
  });

  group('Settings backup save flow', () {
    late Directory temp;
    late AppState state;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      temp = Directory.systemTemp.createTempSync('pm_set_');
      state = AppState(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(temp),
        purchaseService: FakePurchaseService(),
        settings: const AppSettings(onboardingCompleted: true),
      );
    });

    tearDown(() {
      if (temp.existsSync()) {
        temp.deleteSync(recursive: true);
      }
    });

    Future<void> pumpSettings(
      WidgetTester tester, {
      required BackupFileSaver saver,
      Future<AppPackageInfo> Function()? packageInfoLoader,
      Future<bool> Function(Uri uri)? privacyUrlLauncher,
    }) async {
      tester.view.physicalSize = const Size(400, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ListenableBuilder(
            listenable: state,
            builder: (context, _) {
              return SettingsScreen(
                state: state,
                backupFileSaver: saver,
                packageInfoLoader:
                    packageInfoLoader ??
                    () async => const AppPackageInfo(
                      version: '1.0.0',
                      buildNumber: '1',
                    ),
                privacyUrlLauncher: privacyUrlLauncher,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> openCreateBackup(WidgetTester tester) async {
      await tester.scrollUntilVisible(
        find.text('Backup & Restore'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Backup & Restore'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create Backup'));
      await tester.pumpAndSettle();
    }

    testWidgets('cancel save does not update lastBackupAt', (tester) async {
      final saver = _FakeSaver(result: null);
      await pumpSettings(tester, saver: saver);
      await openCreateBackup(tester);

      await tester.enterText(find.byType(TextField).at(0), 'pass1234');
      await tester.enterText(find.byType(TextField).at(1), 'pass1234');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Backup'));
      await tester.pumpAndSettle();

      expect(saver.saveCalls, 1);
      expect(state.settings.lastBackupAt, isNull);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('successful save updates lastBackupAt', (tester) async {
      final saver = _FakeSaver(result: '/tmp/PutMindBackup_test.backup');
      await pumpSettings(tester, saver: saver);
      await openCreateBackup(tester);

      await tester.enterText(find.byType(TextField).at(0), 'pass1234');
      await tester.enterText(find.byType(TextField).at(1), 'pass1234');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Backup'));
      await tester.pumpAndSettle();

      expect(saver.saveCalls, 1);
      expect(saver.lastFileName, contains('PutMindBackup_'));
      expect(saver.lastFileName, endsWith('.backup'));
      expect(saver.lastBytes, isNotNull);
      expect(state.settings.lastBackupAt, isNotNull);
    });

    testWidgets('failed save does not update lastBackupAt', (tester) async {
      final saver = _FakeSaver(throwOnSave: true);
      await pumpSettings(tester, saver: saver);
      await openCreateBackup(tester);

      await tester.enterText(find.byType(TextField).at(0), 'pass1234');
      await tester.enterText(find.byType(TextField).at(1), 'pass1234');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Backup'));
      await tester.pumpAndSettle();

      expect(state.settings.lastBackupAt, isNull);
      expect(state.snackMessage, 'snackBackupSaveFailed');
    });

    testWidgets('lifetime unlocked does not open paywall', (tester) async {
      await state.grantLifetimeEntitlement();
      await pumpSettings(tester, saver: _FakeSaver(result: null));

      await tester.scrollUntilVisible(
        find.text('Upgrade Lifetime'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Lifetime already unlocked'), findsOneWidget);
      await tester.tap(find.text('Upgrade Lifetime'));
      await tester.pumpAndSettle();
      expect(find.text('Unlock unlimited memories'), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('About shows package version/build', (tester) async {
      await pumpSettings(
        tester,
        saver: _FakeSaver(result: null),
        packageInfoLoader: () async =>
            const AppPackageInfo(version: '9.8.7', buildNumber: '42'),
      );

      await tester.scrollUntilVisible(
        find.text('About PutMind'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('About PutMind'));
      await tester.pumpAndSettle();
      expect(find.text('Version 9.8.7 (42)'), findsOneWidget);
      expect(find.textContaining('Step 1'), findsNothing);
    });

    testWidgets('Privacy View Privacy Policy launches URL', (tester) async {
      Uri? launched;
      await pumpSettings(
        tester,
        saver: _FakeSaver(result: null),
        privacyUrlLauncher: (uri) async {
          launched = uri;
          return true;
        },
      );

      await tester.scrollUntilVisible(
        find.text('Privacy'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Privacy'));
      await tester.pumpAndSettle();
      expect(find.text('View Privacy Policy'), findsOneWidget);
      await tester.tap(find.text('View Privacy Policy'));
      await tester.pumpAndSettle();
      expect(launched?.toString(), contains('privacy.html'));
    });
  });

  group('Backup password dialog keyboard', () {
    testWidgets('content remains scrollable with large viewInsets', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showBackupPasswordDialog(context: context, confirm: true);
                    },
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsWidgets);
      expect(find.text('Backup password'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Create Backup'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });
}

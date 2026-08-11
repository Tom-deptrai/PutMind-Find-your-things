import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:putmind/app.dart';
import 'package:putmind/models/memory.dart';
import 'package:putmind/models/settings.dart';
import 'package:putmind/services/image_storage.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/state/app_state.dart';

/// Widget tests use fake-async; avoid async filesystem APIs like createTemp.
Directory _syncTempDir(String name) {
  final dir = Directory('/tmp/$name-${DateTime.now().microsecondsSinceEpoch}')
    ..createSync(recursive: true);
  addTearDown(() {
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  });
  return dir;
}

Future<AppState> _createState({
  List<Memory>? seed,
  AppSettings? settings,
}) async {
  final dir = _syncTempDir('putmind_ui');
  final repo = InMemoryMemoryRepository(seed: seed ?? createSeedMemories());
  return AppState.create(
    repository: repo,
    imageStorage: ImageStorage.forDirectory(dir),
    settings: settings,
  );
}

Future<void> _pumpApp(WidgetTester tester, AppState state) async {
  await tester.pumpWidget(PutMindApp(state: state));
  // Avoid pumpAndSettle — Capture/Waveform timers can keep the scheduler busy.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PutMind UI', () {
    testWidgets('Home shows PutMind title and camera CTA', (tester) async {
      final state = await _createState();
      await _pumpApp(tester, state);

      expect(find.text('PutMind'), findsOneWidget);
      expect(find.text('Recent memories'), findsOneWidget);
      expect(find.text('Passport'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
      expect(find.text('Prototype'), findsOneWidget);
    });

    testWidgets('Capture flow save returns to Home', (tester) async {
      final state = await _createState(seed: const []);
      await _pumpApp(tester, state);

      expect(find.text('Your things will appear here.'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.camera_alt_rounded));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      state.takePhoto(mockImagePath: 'mock-captured');
      await tester.pump(const Duration(milliseconds: 100));
      state.setCaptureTranscript('Passport, in the desk drawer.');
      await tester.pump();

      await tester.tap(find.text('Save memory'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('PutMind'), findsOneWidget);
      expect(find.textContaining('Passport'), findsWidgets);
    });

    testWidgets('Settings opens from Home', (tester) async {
      final state = await _createState();
      await _pumpApp(tester, state);

      await tester.tap(find.byTooltip('Settings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Voice Guidance'), findsOneWidget);
      expect(find.text('App Lock'), findsOneWidget);
      expect(find.text('PutMind Lifetime'), findsOneWidget);
    });

    testWidgets('Prototype navigator can open Unlock', (tester) async {
      final state = await _createState();
      await _pumpApp(tester, state);

      await tester.tap(find.text('Prototype'));
      await tester.pump();
      await tester.tap(find.text('Unlock'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Unlock PutMind'), findsOneWidget);
      await tester.tap(find.text('Unlock with biometrics'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('PutMind'), findsOneWidget);
    });

    testWidgets('Prototype navigator can open Onboarding', (tester) async {
      final state = await _createState();
      await _pumpApp(tester, state);

      await tester.tap(find.text('Prototype'));
      await tester.pump();
      await tester.tap(find.text('Onboarding'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Snap it.'), findsOneWidget);
    });

    testWidgets('Prototype navigator can open Empty Home', (tester) async {
      final state = await _createState();
      await _pumpApp(tester, state);

      await tester.tap(find.text('Prototype'));
      await tester.pump();
      await tester.tap(find.text('Empty Home'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Your things will appear here.'), findsOneWidget);
    });

    testWidgets('search opens Memory Detail sheet', (tester) async {
      final state = await _createState();
      await _pumpApp(tester, state);

      await tester.enterText(find.byType(TextField), 'passport');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Passport'), findsOneWidget);
      await tester.tap(find.text('Passport'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Replace photo'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('Prototype Paywall and Unlock PIN work', (tester) async {
      final state = await _createState();
      await _pumpApp(tester, state);

      await tester.tap(find.text('Prototype'));
      await tester.pump();
      await tester.tap(find.text('Paywall'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Unlock unlimited memories'), findsOneWidget);
      expect(find.text(r'$6.99'), findsOneWidget);
      await tester.tap(find.text('Unlock Lifetime'));
      await tester.pump();

      await tester.tap(find.text('Prototype'));
      await tester.pump();
      await tester.tap(find.text('Unlock'));
      await tester.pump();
      await tester.tap(find.text('Use PIN instead'));
      await tester.pump();
      expect(find.text('Enter PIN'), findsOneWidget);

      for (final digit in ['1', '2', '3', '4']) {
        await tester.tap(find.text(digit));
        await tester.pump();
      }
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('PutMind'), findsOneWidget);
    });

    testWidgets('starts on Unlock when App Lock is on', (tester) async {
      final state = await _createState(
        settings: const AppSettings(appLock: true),
      );
      await _pumpApp(tester, state);

      expect(find.text('Unlock PutMind'), findsOneWidget);
      expect(find.text('Passport'), findsNothing);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:putmind/app.dart';
import 'package:putmind/models/settings.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppState', () {
    test('seeds demo memories and starts on Home', () {
      final state = AppState();
      expect(state.route, AppRoute.home);
      expect(state.memories.length, 3);
      expect(state.settings.appLock, isFalse);
      expect(state.settings.voiceGuidance, isTrue);
    });

    test('search filters memories', () {
      final state = AppState();
      state.setSearchQuery('passport');
      expect(state.filteredMemories, hasLength(1));
      expect(state.filteredMemories.first.title, 'Passport');
    });

    test('save memory adds to home list', () async {
      final state = AppState(seedDemoMemories: false);
      expect(state.memories, isEmpty);

      state.openCapture();
      state.takePhoto();
      // Skip waiting for mock speech; type transcript directly.
      state.setCaptureTranscript('Spare keys, in the kitchen drawer.');
      final saved = await state.saveMemory();

      expect(saved, isTrue);
      expect(state.route, AppRoute.home);
      expect(state.memories, hasLength(1));
      expect(state.memories.first.transcript, contains('Spare keys'));
    });

    test('paywall blocks memory 21 for free users', () async {
      final repo = InMemoryMemoryRepository(
        seed: List.generate(
          20,
          (i) => createSeedMemories().first.copyWith(
            id: 'm-$i',
            transcript: 'Item $i, location $i',
          ),
        ),
      );
      final state = AppState(repository: repo, seedDemoMemories: false);
      expect(state.memoryCount, 20);
      expect(state.canAddMemory, isFalse);

      state.openCapture();
      state.takePhoto();
      state.setCaptureTranscript('Too many, in a box.');
      final saved = await state.saveMemory();

      expect(saved, isFalse);
      expect(state.showPaywall, isTrue);
      expect(state.memoryCount, 20);
    });

    test('delete memory removes it', () async {
      final state = AppState();
      final first = state.memories.first;
      state.openMemoryDetail(first);
      await state.confirmDeleteSelected();
      expect(state.memories.any((m) => m.id == first.id), isFalse);
    });
  });

  group('PutMind UI', () {
    testWidgets('Home shows PutMind title and camera CTA', (tester) async {
      final state = AppState();
      await tester.pumpWidget(PutMindApp(state: state));
      await tester.pumpAndSettle();

      expect(find.text('PutMind'), findsOneWidget);
      expect(find.text('Recent memories'), findsOneWidget);
      expect(find.text('Passport'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
      expect(find.text('Prototype'), findsOneWidget);
    });

    testWidgets('Capture flow save returns to Home', (tester) async {
      final state = AppState(seedDemoMemories: false);
      await tester.pumpWidget(PutMindApp(state: state));
      await tester.pumpAndSettle();

      expect(find.text('Your things will appear here.'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.camera_alt_rounded));
      await tester.pumpAndSettle();

      // Tap shutter (outer circle gesture detector area via camera mock).
      state.takePhoto();
      await tester.pump(const Duration(milliseconds: 100));
      state.setCaptureTranscript('Passport, in the desk drawer.');
      await tester.pump();

      await tester.tap(find.text('Save memory'));
      await tester.pumpAndSettle();

      expect(find.text('PutMind'), findsOneWidget);
      expect(find.textContaining('Passport'), findsWidgets);
    });

    testWidgets('Settings opens from Home', (tester) async {
      final state = AppState();
      await tester.pumpWidget(PutMindApp(state: state));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Voice Guidance'), findsOneWidget);
      expect(find.text('App Lock'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Upgrade Lifetime'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Upgrade Lifetime'), findsOneWidget);
    });

    testWidgets('Prototype navigator can open Unlock', (tester) async {
      final state = AppState();
      await tester.pumpWidget(PutMindApp(state: state));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Prototype'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      expect(find.text('Unlock PutMind'), findsOneWidget);
      await tester.tap(find.text('Unlock with biometrics'));
      await tester.pumpAndSettle();
      expect(find.text('PutMind'), findsOneWidget);
    });

    testWidgets('Prototype navigator can open Onboarding', (tester) async {
      final state = AppState();
      await tester.pumpWidget(PutMindApp(state: state));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Prototype'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Onboarding'));
      await tester.pumpAndSettle();

      expect(find.text('Snap it.'), findsOneWidget);
    });

    testWidgets('Prototype navigator can open Empty Home', (tester) async {
      final state = AppState();
      await tester.pumpWidget(PutMindApp(state: state));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Prototype'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Empty Home'));
      await tester.pumpAndSettle();

      expect(find.text('Your things will appear here.'), findsOneWidget);
    });

    testWidgets('starts on Unlock when App Lock is on', (tester) async {
      final state = AppState(settings: const AppSettings(appLock: true));
      await tester.pumpWidget(PutMindApp(state: state));
      await tester.pumpAndSettle();

      expect(find.text('Unlock PutMind'), findsOneWidget);
      expect(find.text('Passport'), findsNothing);
    });
  });
}

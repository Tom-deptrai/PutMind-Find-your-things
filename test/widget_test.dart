import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:putmind/app.dart';
import 'package:putmind/models/memory.dart';
import 'package:putmind/models/settings.dart';
import 'package:putmind/services/image_storage.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/services/settings_store.dart';
import 'package:putmind/state/app_state.dart';
import 'package:putmind/widgets/app_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferences.setMockInitialValues({});
  final dir = _syncTempDir('putmind_ui');
  final repo = InMemoryMemoryRepository(seed: seed ?? createSeedMemories());
  return AppState.create(
    repository: repo,
    imageStorage: ImageStorage.forDirectory(dir),
    settingsStore: SettingsStore(),
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
      expect(
        find.textContaining('Passport, in the second drawer'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
      expect(find.text('Prototype'), findsNothing);
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

    testWidgets('search opens Memory Detail sheet', (tester) async {
      final state = await _createState();
      await _pumpApp(tester, state);

      await tester.enterText(find.byType(TextField), 'passport');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(
        find.textContaining('Passport, in the second drawer'),
        findsOneWidget,
      );
      await tester.tap(find.textContaining('Passport, in the second drawer'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Replace photo'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('Edit → Save updates transcript without crash', (tester) async {
      final state = await _createState();
      final original = state.memories.first;
      final beforeUpdatedAt = original.updatedAt;
      await _pumpApp(tester, state);

      // Hold selection as Home does after the detail sheet returns edit.
      state.openMemoryDetail(original);
      await tester.pump();
      expect(state.selectedMemory?.id, original.id);

      final navContext = tester.element(find.byType(Scaffold).first);
      final resultFuture = showEditTranscriptDialog(
        context: navContext,
        initialText: original.transcript,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Edit memory'), findsOneWidget);

      await tester.enterText(
        find.byType(TextField).last,
        'Passport, moved to the safe.',
      );
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(await resultFuture, 'Passport, moved to the safe.');
      expect(tester.takeException(), isNull);
      // Selection still valid for the subsequent repository update.
      expect(state.selectedMemory?.id, original.id);
      await state.updateSelectedTranscript('Passport, moved to the safe.');
      await tester.pump();

      final updated = state.memories.firstWhere((m) => m.id == original.id);
      expect(updated.transcript, 'Passport, moved to the safe.');
      expect(updated.updatedAt.isAfter(beforeUpdatedAt), isTrue);
      expect(find.textContaining('Passport, moved to the safe.'), findsWidgets);
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

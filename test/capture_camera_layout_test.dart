import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:putmind/l10n/app_localizations.dart';
import 'package:putmind/models/memory.dart';
import 'package:putmind/models/settings.dart';
import 'package:putmind/services/camera_session_gate.dart';
import 'package:putmind/services/image_storage.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/state/app_state.dart';
import 'package:putmind/theme/app_typography.dart';
import 'package:putmind/widgets/memory_card.dart';
import 'package:putmind/app.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CameraSessionGate', () {
    test('operations run strictly serially (no overlap)', () async {
      final gate = CameraSessionGate();
      final order = <String>[];
      var overlapping = false;
      var active = 0;

      Future<void> tracked(String label, int ms) {
        return gate.run(() async {
          active++;
          if (active > 1) overlapping = true;
          order.add('start-$label');
          await Future<void>.delayed(Duration(milliseconds: ms));
          order.add('end-$label');
          active--;
        });
      }

      await Future.wait([tracked('a', 40), tracked('b', 10), tracked('c', 10)]);

      expect(overlapping, isFalse);
      expect(order, [
        'start-a',
        'end-a',
        'start-b',
        'end-b',
        'start-c',
        'end-c',
      ]);
      expect(gate.isBusy, isFalse);
    });

    test('dispose-then-init ordering is preserved under burst', () async {
      final gate = CameraSessionGate();
      final log = <String>[];

      Future<void> disposeOp() => gate.run(() async {
        log.add('dispose');
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      Future<void> initOp() => gate.run(() async {
        log.add('init');
      });

      // Mimic takePicture release then immediate Add Photo prepare.
      final release = disposeOp();
      final prepare = initOp();
      await Future.wait([release, prepare]);
      expect(log, ['dispose', 'init']);
    });
  });

  group('Add Photo state preserves draft', () {
    test('startAddPhoto keeps transcript and existing photos', () async {
      final dir = Directory.systemTemp.createTempSync('pm_cam_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });
      final state = await AppState.create(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(dir),
        settings: const AppSettings(voiceGuidance: false),
      );
      addTearDown(state.dispose);

      state.openCapture();
      state.takePhoto(mockImagePath: 'mock-1');
      state.setCaptureTranscript('Keep this transcript');
      state.startAddPhoto();
      expect(state.capturePhase, CapturePhase.preview);
      expect(state.captureMode, CaptureMode.addPhoto);
      expect(state.captureTranscript, 'Keep this transcript');
      expect(state.captureImagePaths, ['mock-1']);

      state.takePhoto(mockImagePath: 'mock-2');
      expect(state.captureTranscript, 'Keep this transcript');
      expect(state.captureImagePaths, ['mock-1', 'mock-2']);
      expect(state.captureMode, CaptureMode.create);

      // Repeated Add Photo
      state.startAddPhoto();
      state.takePhoto(mockImagePath: 'mock-3');
      expect(state.captureImagePaths, ['mock-1', 'mock-2', 'mock-3']);
      expect(state.captureTranscript, 'Keep this transcript');
    });

    test('Retake and Replace still preserve non-target photos', () async {
      final dir = Directory.systemTemp.createTempSync('pm_cam2_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });
      final state = await AppState.create(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(dir),
        settings: const AppSettings(voiceGuidance: false),
      );
      addTearDown(state.dispose);

      state.openCapture();
      state.takePhoto(mockImagePath: 'mock-a');
      state.setCaptureTranscript('T');
      state.startAddPhoto();
      state.takePhoto(mockImagePath: 'mock-b');
      state.startAddPhoto();
      state.takePhoto(mockImagePath: 'mock-c');
      state.retake();
      expect(state.captureImagePaths, ['mock-a', 'mock-b']);
      expect(state.captureTranscript, 'T');
      state.takePhoto(mockImagePath: 'mock-c2');
      expect(state.captureImagePaths, ['mock-a', 'mock-b', 'mock-c2']);
    });
  });

  group('Capture action layout + typography', () {
    Future<AppState> pumpCapture(WidgetTester tester) async {
      final dir = Directory.systemTemp.createTempSync('pm_ui_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });
      final state = await AppState.create(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(dir),
        settings: const AppSettings(
          voiceGuidance: false,
          onboardingCompleted: true,
        ),
      );
      addTearDown(state.dispose);
      await tester.pumpWidget(PutMindApp(state: state));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      state.openCapture();
      await tester.pump();
      state.takePhoto(mockImagePath: 'mock-1');
      state.setCaptureTranscript('Keys, drawer');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      return state;
    }

    testWidgets('Retake + Add Photo on first row; Save full-width second row', (
      tester,
    ) async {
      await pumpCapture(tester);

      final retake = find.text('Retake');
      final add = find.text('Add photo');
      final save = find.text('Save memory');
      expect(retake, findsOneWidget);
      expect(add, findsOneWidget);
      expect(save, findsOneWidget);

      final retakeY = tester.getCenter(retake).dy;
      final addY = tester.getCenter(add).dy;
      final saveY = tester.getCenter(save).dy;
      expect((retakeY - addY).abs() < 8, isTrue);
      expect(saveY > retakeY + 20, isTrue);

      final saveWidth = tester
          .getSize(find.widgetWithText(ElevatedButton, 'Save memory'))
          .width;
      final retakeWidth = tester
          .getSize(find.widgetWithText(OutlinedButton, 'Retake'))
          .width;
      // Save is full-width — clearly wider than one secondary button.
      expect(saveWidth > retakeWidth * 1.5, isTrue);
    });

    testWidgets('long DE labels render fully on narrow phone', (tester) async {
      final dir = Directory.systemTemp.createTempSync('pm_l10n_');
      addTearDown(() {
        if (dir.existsSync()) dir.deleteSync(recursive: true);
      });
      final state = await AppState.create(
        repository: InMemoryMemoryRepository(),
        imageStorage: ImageStorage.forDirectory(dir),
        settings: const AppSettings(
          voiceGuidance: false,
          onboardingCompleted: true,
          language: AppLanguage.german,
        ),
      );
      addTearDown(state.dispose);

      await tester.binding.setSurfaceSize(const Size(320, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(PutMindApp(state: state));
      await tester.pump();
      state.openCapture();
      await tester.pump();
      state.takePhoto(mockImagePath: 'mock-1');
      state.setCaptureTranscript('Schlüssel');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final de = lookupAppLocalizations(const Locale('de'));
      expect(find.text(de.captureRetake), findsOneWidget);
      expect(find.text(de.captureAddPhoto), findsOneWidget);
      expect(find.text(de.captureSave), findsOneWidget);

      final retakeText = tester.widget<Text>(find.text(de.captureRetake));
      final addText = tester.widget<Text>(find.text(de.captureAddPhoto));
      final saveText = tester.widget<Text>(find.text(de.captureSave));
      expect(retakeText.overflow, isNot(TextOverflow.ellipsis));
      expect(addText.overflow, isNot(TextOverflow.ellipsis));
      expect(saveText.overflow, isNot(TextOverflow.ellipsis));
    });

    testWidgets('MemoryCard transcript uses regular weight, not title bold', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MemoryCard(
              memory: Memory(
                id: '1',
                transcript: 'Regular body transcript',
                createdAt: DateTime.utc(2026, 1, 1),
                updatedAt: DateTime.utc(2026, 1, 1),
                imagePaths: const ['mock'],
              ),
              onTap: () {},
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Regular body transcript'));
      expect(text.style?.fontWeight, FontWeight.w400);
      expect(
        text.style?.fontWeight == AppTypography.memoryTitle.fontWeight,
        isFalse,
      );
    });
  });
}

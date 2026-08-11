import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:putmind/models/settings.dart';
import 'package:putmind/services/image_storage.dart';
import 'package:putmind/services/memory_repository.dart';
import 'package:putmind/services/purchase_service.dart';
import 'package:putmind/services/speech_service.dart';
import 'package:putmind/services/voice_guidance_player.dart';
import 'package:putmind/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory temp;
  late FakeSpeechService speech;
  late _DeferredVoicePlayer voice;
  late AppState state;

  setUp(() {
    temp = Directory.systemTemp.createTempSync('pm_capture_fix_');
    speech = FakeSpeechService();
    voice = _DeferredVoicePlayer();
    state = AppState(
      repository: InMemoryMemoryRepository(),
      imageStorage: ImageStorage.forDirectory(
        Directory(p.join(temp.path, 'images'))..createSync(),
      ),
      purchaseService: FakePurchaseService(),
      speechService: speech,
      voiceGuidancePlayer: voice,
      settings: const AppSettings(
        onboardingCompleted: true,
        voiceGuidance: true,
        language: AppLanguage.english,
      ),
    );
  });

  tearDown(() async {
    if (temp.existsSync()) {
      temp.deleteSync(recursive: true);
    }
  });

  test(
    'Voice Guidance ON → speech starts only after playback completes',
    () async {
      state.takePhoto(mockImagePath: 'mock-captured');
      expect(state.capturePhase, CapturePhase.guiding);
      expect(speech.listenCount, 0);

      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(state.capturePhase, CapturePhase.guiding);
      expect(speech.listenCount, 0);

      voice.complete();
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(state.capturePhase, CapturePhase.listening);
      expect(speech.listenCount, 1);
      expect(speech.lastListenFor, kCaptureListenFor);
      expect(speech.lastPauseFor, kCapturePauseFor);
    },
  );

  test('playback failure → speech still starts', () async {
    final failing = AppState(
      repository: InMemoryMemoryRepository(),
      imageStorage: ImageStorage.forDirectory(
        Directory(p.join(temp.path, 'images2'))..createSync(),
      ),
      purchaseService: FakePurchaseService(),
      speechService: speech,
      voiceGuidancePlayer: _ThrowingVoicePlayer(),
      settings: const AppSettings(
        onboardingCompleted: true,
        voiceGuidance: true,
      ),
    );
    failing.takePhoto(mockImagePath: 'mock-captured');
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(failing.capturePhase, CapturePhase.listening);
    expect(speech.listenCount, 1);
  });

  test('manual text focus stops speech and does not auto-restart', () async {
    voice.completeImmediately = true;
    state.takePhoto(mockImagePath: 'mock-captured');
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(state.capturePhase, CapturePhase.listening);
    final listensBefore = speech.listenCount;

    await state.beginManualEditing();
    expect(state.capturePhase, CapturePhase.editing);
    expect(speech.stopCount, greaterThan(0));

    speech.emitNotListening();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    expect(speech.listenCount, listensBefore);
    expect(state.capturePhase, CapturePhase.editing);
  });

  test(
    'unexpected speech end restarts only while still in voice mode',
    () async {
      voice.completeImmediately = true;
      state.takePhoto(mockImagePath: 'mock-captured');
      await Future<void>.delayed(const Duration(milliseconds: 40));
      expect(speech.listenCount, 1);

      speech.emitResult('Keys in');
      expect(state.captureTranscript, 'Keys in');

      speech.emitNotListening();
      await Future<void>.delayed(const Duration(milliseconds: 250));
      expect(speech.listenCount, 2);
      expect(state.capturePhase, CapturePhase.listening);
      expect(state.captureTranscript, 'Keys in');

      speech.emitResult('the drawer');
      expect(state.captureTranscript, 'Keys in the drawer');
    },
  );

  test('Save / Retake stop speech', () async {
    voice.completeImmediately = true;
    state.takePhoto(mockImagePath: 'mock-captured');
    await Future<void>.delayed(const Duration(milliseconds: 40));
    state.setCaptureTranscript('Wallet, in the bag.');
    final ok = await state.saveMemory();
    expect(ok, isTrue);
    expect(speech.cancelCount + speech.stopCount, greaterThan(0));

    final speech2 = FakeSpeechService();
    final voice2 = _DeferredVoicePlayer()..completeImmediately = true;
    final state2 = AppState(
      repository: InMemoryMemoryRepository(),
      imageStorage: ImageStorage.forDirectory(
        Directory(p.join(temp.path, 'images3'))..createSync(),
      ),
      purchaseService: FakePurchaseService(),
      speechService: speech2,
      voiceGuidancePlayer: voice2,
      settings: const AppSettings(
        onboardingCompleted: true,
        voiceGuidance: true,
      ),
    );
    state2.takePhoto(mockImagePath: 'mock-captured');
    await Future<void>.delayed(const Duration(milliseconds: 40));
    state2.retake();
    expect(state2.capturePhase, CapturePhase.preview);
    expect(speech2.cancelCount, greaterThan(0));
  });

  testWidgets('Capture sheet layout tolerates large keyboard inset', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 740));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    // Mirrors CaptureScreen architecture: flex preview + scrollable sheet,
    // without camera/waveform timers that keep the scheduler busy.
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(360, 740),
          viewInsets: EdgeInsets.only(bottom: 245),
          padding: EdgeInsets.only(bottom: 24),
        ),
        child: MaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                const SizedBox(height: 58, child: Text('header')),
                const Expanded(flex: 5, child: ColoredBox(color: Colors.black)),
                Flexible(
                  flex: 6,
                  child: Material(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 46),
                      child: Column(
                        children: [
                          const TextField(
                            decoration: InputDecoration(hintText: 'transcript'),
                            minLines: 2,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Save memory'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Save memory'), findsOneWidget);
  });
}

class _DeferredVoicePlayer extends VoiceGuidancePlayer {
  Completer<void> _gate = Completer<void>();
  bool completeImmediately = false;

  void complete() {
    if (!_gate.isCompleted) _gate.complete();
  }

  @override
  Future<void> play(AppLanguage language) async {
    if (completeImmediately) return;
    _gate = Completer<void>();
    await _gate.future;
  }
}

class _ThrowingVoicePlayer extends VoiceGuidancePlayer {
  @override
  Future<void> play(AppLanguage language) async {
    throw StateError('simulated playback failure');
  }
}

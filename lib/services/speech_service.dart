import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef SpeechPartialCallback = void Function(String text);
typedef SpeechStatusCallback = void Function(SpeechListenStatus status);

enum SpeechListenStatus {
  listening,
  notListening,
  done,
  unavailable,
  permissionDenied,
  error,
}

/// Default Capture dictation window (platform may still end earlier).
const Duration kCaptureListenFor = Duration(seconds: 90);

/// Allow natural pauses without ending the session.
const Duration kCapturePauseFor = Duration(seconds: 6);

/// On-device speech recognition wrapper.
class SpeechService {
  SpeechService({SpeechToText? speech}) : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;
  bool _available = false;
  bool _sessionWanted = false;
  SpeechStatusCallback? _activeStatus;

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    if (kIsWeb) {
      _available = false;
      _initialized = true;
      return false;
    }
    if (_initialized) return _available;
    try {
      _available = await _speech.initialize(
        onError: (_) {
          _sessionWanted = false;
          _activeStatus?.call(SpeechListenStatus.error);
        },
        onStatus: (status) {
          if (status == 'listening') {
            _activeStatus?.call(SpeechListenStatus.listening);
            return;
          }
          if (status == 'notListening' || status == 'done') {
            if (!_sessionWanted) return;
            _sessionWanted = false;
            _activeStatus?.call(SpeechListenStatus.notListening);
          }
        },
      );
    } catch (_) {
      _available = false;
    }
    _initialized = true;
    return _available;
  }

  Future<void> listen({
    required String localeId,
    required SpeechPartialCallback onResult,
    required SpeechStatusCallback onStatus,
    Duration listenFor = kCaptureListenFor,
    Duration pauseFor = kCapturePauseFor,
    ListenMode listenMode = ListenMode.dictation,
  }) async {
    final ok = await initialize();
    if (!ok) {
      onStatus(SpeechListenStatus.unavailable);
      return;
    }

    try {
      if (_speech.isListening) {
        await _speech.stop();
      }
    } catch (_) {}

    _activeStatus = onStatus;
    _sessionWanted = true;
    onStatus(SpeechListenStatus.listening);

    try {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenFor: listenFor,
          pauseFor: pauseFor,
          partialResults: true,
          cancelOnError: true,
          listenMode: listenMode,
          autoPunctuation: true,
        ),
      );
    } catch (_) {
      _sessionWanted = false;
      onStatus(SpeechListenStatus.error);
    }
  }

  Future<void> stop() async {
    _sessionWanted = false;
    _activeStatus = null;
    if (!_initialized) return;
    try {
      await _speech.stop();
    } catch (_) {}
  }

  Future<void> cancel() async {
    _sessionWanted = false;
    _activeStatus = null;
    if (!_initialized) return;
    try {
      await _speech.cancel();
    } catch (_) {}
  }
}

/// Controllable speech stub for unit/widget tests.
class FakeSpeechService extends SpeechService {
  FakeSpeechService({this.available = true});

  final bool available;
  int listenCount = 0;
  int stopCount = 0;
  int cancelCount = 0;
  bool autoEmitNotListening = false;
  SpeechPartialCallback? lastOnResult;
  SpeechStatusCallback? lastOnStatus;
  String? lastLocaleId;
  Duration? lastListenFor;
  Duration? lastPauseFor;

  @override
  bool get isAvailable => available;

  @override
  bool get isListening => listenCount > stopCount + cancelCount;

  @override
  Future<bool> initialize() async => available;

  @override
  Future<void> listen({
    required String localeId,
    required SpeechPartialCallback onResult,
    required SpeechStatusCallback onStatus,
    Duration listenFor = kCaptureListenFor,
    Duration pauseFor = kCapturePauseFor,
    ListenMode listenMode = ListenMode.dictation,
  }) async {
    if (!available) {
      onStatus(SpeechListenStatus.unavailable);
      return;
    }
    listenCount++;
    lastLocaleId = localeId;
    lastOnResult = onResult;
    lastOnStatus = onStatus;
    lastListenFor = listenFor;
    lastPauseFor = pauseFor;
    onStatus(SpeechListenStatus.listening);
    if (autoEmitNotListening) {
      scheduleMicrotask(() => onStatus(SpeechListenStatus.notListening));
    }
  }

  void emitResult(String text) => lastOnResult?.call(text);

  void emitNotListening() =>
      lastOnStatus?.call(SpeechListenStatus.notListening);

  @override
  Future<void> stop() async {
    stopCount++;
  }

  @override
  Future<void> cancel() async {
    cancelCount++;
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

typedef SpeechPartialCallback = void Function(String text);
typedef SpeechStatusCallback = void Function(SpeechListenStatus status);

enum SpeechListenStatus {
  listening,
  done,
  unavailable,
  permissionDenied,
  error,
}

/// On-device speech recognition wrapper.
class SpeechService {
  SpeechService({SpeechToText? speech}) : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;
  bool _available = false;

  bool get isAvailable => _available;

  Future<bool> initialize() async {
    if (kIsWeb) {
      _available = false;
      _initialized = true;
      return false;
    }
    if (_initialized) return _available;
    try {
      _available = await _speech.initialize(onError: (_) {}, onStatus: (_) {});
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
    Duration listenFor = const Duration(seconds: 30),
  }) async {
    final ok = await initialize();
    if (!ok) {
      onStatus(SpeechListenStatus.unavailable);
      return;
    }

    onStatus(SpeechListenStatus.listening);
    try {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
          if (result.finalResult) {
            onStatus(SpeechListenStatus.done);
          }
        },
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenFor: listenFor,
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          cancelOnError: true,
          listenMode: ListenMode.confirmation,
        ),
      );
    } catch (_) {
      onStatus(SpeechListenStatus.error);
    }
  }

  Future<void> stop() async {
    if (!_initialized) return;
    try {
      await _speech.stop();
    } catch (_) {}
  }

  Future<void> cancel() async {
    if (!_initialized) return;
    try {
      await _speech.cancel();
    } catch (_) {}
  }
}

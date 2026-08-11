import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/settings.dart';

/// Plays bundled Voice Guidance audio (no runtime cloud TTS).
class VoiceGuidancePlayer {
  VoiceGuidancePlayer({AudioPlayer? player}) : _injected = player;

  final AudioPlayer? _injected;
  AudioPlayer? _player;
  int _playGeneration = 0;

  AudioPlayer? _resolvePlayer() {
    if (kIsWeb) return null;
    return _injected ?? (_player ??= AudioPlayer());
  }

  /// Asset path for [language] (bundled production WAV).
  static String assetPathFor(AppLanguage language) {
    return 'assets/voice_guidance/${language.voiceGuidanceLocale}.wav';
  }

  /// Plays guidance for [language]. Completes only after playback ends,
  /// or immediately on failure / missing player (caller may start STT).
  Future<void> play(AppLanguage language) async {
    final generation = ++_playGeneration;
    if (kIsWeb) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return;
    }
    final player = _resolvePlayer();
    if (player == null) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return;
    }

    StreamSubscription<void>? completeSub;
    try {
      // Avoid media ducking / early STT focus fighting guidance audio.
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setPlayerMode(PlayerMode.mediaPlayer);
      await player.stop();

      // Subscribe AFTER stop so a stop-related complete cannot unblock early.
      final done = Completer<void>();
      completeSub = player.onPlayerComplete.listen((_) {
        if (!done.isCompleted) done.complete();
      });

      await player.play(
        AssetSource('voice_guidance/${language.voiceGuidanceLocale}.wav'),
      );
      if (generation != _playGeneration) return;

      // Bound wait to a long ceiling; do not use short fixed "speech start" delays.
      await done.future.timeout(const Duration(seconds: 30));
    } on TimeoutException {
      // Still proceed — STT must not be blocked forever.
    } catch (_) {
      // Missing/corrupt asset or play error → caller starts listening.
    } finally {
      await completeSub?.cancel();
    }
  }

  Future<void> stop() async {
    _playGeneration++;
    try {
      await _player?.stop();
      await _injected?.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    _playGeneration++;
    try {
      await _player?.dispose();
      _player = null;
    } catch (_) {}
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../models/settings.dart';

/// Plays bundled Voice Guidance audio (no runtime cloud TTS).
class VoiceGuidancePlayer {
  VoiceGuidancePlayer({AudioPlayer? player}) : _injected = player;

  final AudioPlayer? _injected;
  AudioPlayer? _player;

  AudioPlayer? _resolvePlayer() {
    if (kIsWeb) return null;
    return _injected ?? (_player ??= AudioPlayer());
  }

  /// Asset path for [language] (bundled production WAV).
  static String assetPathFor(AppLanguage language) {
    return 'assets/voice_guidance/${language.voiceGuidanceLocale}.wav';
  }

  /// Plays guidance for [language]. Completes when playback ends or fails.
  Future<void> play(AppLanguage language) async {
    if (kIsWeb) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return;
    }
    final player = _resolvePlayer();
    if (player == null) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return;
    }
    try {
      await player.stop();
      await player.play(
        AssetSource('voice_guidance/${language.voiceGuidanceLocale}.wav'),
      );
      await player.onPlayerComplete.first.timeout(
        const Duration(seconds: 8),
        onTimeout: () {},
      );
    } catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> stop() async {
    try {
      await _player?.stop();
      await _injected?.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    try {
      await _player?.dispose();
    } catch (_) {}
  }
}

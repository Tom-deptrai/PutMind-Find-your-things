import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/settings.dart';

/// Local persistence for non-secret AppSettings.
class SettingsStore {
  SettingsStore({SharedPreferences? prefs}) : _prefs = prefs;

  static const _key = 'putmind.settings.v1';

  SharedPreferences? _prefs;
  AppSettings? _memoryFallback;
  final bool _testMode = Platform.environment.containsKey('FLUTTER_TEST');

  Future<SharedPreferences?> _ensure() async {
    if (_testMode) return _prefs;
    if (_prefs != null) return _prefs;
    try {
      _prefs = await SharedPreferences.getInstance();
      return _prefs;
    } catch (_) {
      return null;
    }
  }

  Future<AppSettings> load() async {
    final prefs = await _ensure();
    if (prefs == null) return _memoryFallback ?? const AppSettings();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return _memoryFallback ?? const AppSettings();
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return AppSettings.fromJson(map);
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> save(AppSettings settings) async {
    _memoryFallback = settings;
    final prefs = await _ensure();
    if (prefs == null) return;
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}

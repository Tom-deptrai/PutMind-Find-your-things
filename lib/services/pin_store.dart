import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores App Lock PIN as salted hash — never plaintext.
class PinStore {
  PinStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage(),
      _useMemory = kIsWeb || Platform.environment.containsKey('FLUTTER_TEST');

  static const _hashKey = 'putmind.app_lock.pin_hash';
  static const _saltKey = 'putmind.app_lock.pin_salt';

  final FlutterSecureStorage _storage;
  final bool _useMemory;

  Future<bool> hasPin() async {
    if (_useMemory) return _memHash != null;
    final hash = await _storage.read(key: _hashKey);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    final salt = _randomSalt();
    final hash = _hash(pin, salt);
    if (_useMemory) {
      _memSalt = salt;
      _memHash = hash;
      return;
    }
    await _storage.write(key: _saltKey, value: salt);
    await _storage.write(key: _hashKey, value: hash);
  }

  Future<bool> verifyPin(String pin) async {
    String? salt;
    String? hash;
    if (_useMemory) {
      salt = _memSalt;
      hash = _memHash;
    } else {
      salt = await _storage.read(key: _saltKey);
      hash = await _storage.read(key: _hashKey);
    }
    if (salt == null || hash == null) return false;
    return _hash(pin, salt) == hash;
  }

  Future<void> clear() async {
    if (_useMemory) {
      _memSalt = null;
      _memHash = null;
      return;
    }
    await _storage.delete(key: _hashKey);
    await _storage.delete(key: _saltKey);
  }

  String? _memSalt;
  String? _memHash;

  static String _randomSalt() {
    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    return base64UrlEncode(bytes);
  }

  static String _hash(String pin, String salt) {
    final digest = sha256.convert(utf8.encode('$salt::$pin'));
    return digest.toString();
  }
}

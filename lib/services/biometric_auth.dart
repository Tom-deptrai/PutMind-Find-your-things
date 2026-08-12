import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io' show Platform;

/// Biometric authentication adapter (no-op / unavailable on web).
class BiometricAuth {
  BiometricAuth({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  /// Test double that never touches platform channels.
  BiometricAuth.fake({bool available = true, bool authSucceeds = true})
    : _auth = null,
      _fakeAvailable = available,
      _fakeAuthSucceeds = authSucceeds;

  final LocalAuthentication? _auth;
  bool? _fakeAvailable;
  bool? _fakeAuthSucceeds;

  /// Test helper — flip capability between cold-start and resume probes.
  void debugSetAvailable(bool value) {
    _fakeAvailable = value;
  }

  Future<bool> get isAvailable async {
    final fake = _fakeAvailable;
    if (fake != null) return fake;
    if (kIsWeb) return false;
    // Avoid hanging on missing platform-channel mocks in unit/widget tests.
    if (Platform.environment.containsKey('FLUTTER_TEST')) return false;
    final auth = _auth;
    if (auth == null) return false;
    try {
      final can = await auth.canCheckBiometrics;
      final supported = await auth.isDeviceSupported();
      return can || supported;
    } catch (_) {
      return false;
    }
  }

  /// Returns true on success. Does not log biometric details.
  ///
  /// Uses [biometricOnly] so the OS does not silently offer device passcode;
  /// PutMind's own PIN fallback remains the in-app path.
  Future<bool> authenticate({required String localizedReason}) async {
    final fake = _fakeAuthSucceeds;
    if (fake != null) return fake;
    if (kIsWeb) return false;
    if (Platform.environment.containsKey('FLUTTER_TEST')) return false;
    final auth = _auth;
    if (auth == null) return false;
    try {
      return await auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}

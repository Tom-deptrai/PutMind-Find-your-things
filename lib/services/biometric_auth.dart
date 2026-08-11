import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Biometric authentication adapter (no-op / unavailable on web).
class BiometricAuth {
  BiometricAuth({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  Future<bool> get isAvailable async {
    if (kIsWeb) return false;
    try {
      final can = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();
      return can || supported;
    } catch (_) {
      return false;
    }
  }

  /// Returns true on success. Does not log biometric details.
  Future<bool> authenticate({required String localizedReason}) async {
    if (kIsWeb) return false;
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}

import 'biometric_fingerprint_platform_interface.dart';
import 'biometric_result.dart';

class BiometricFingerprint {

  Future<String?> getPlatformVersion() {
    return BiometricFingerprintPlatform.instance.getPlatformVersion();
  }

  /// Get the [BiometricType] available on the device.
  ///
  /// [BiometricType.FACE]
  /// [BiometricType.FINGERPRINT]
  /// [BiometricType.IRIS]
  /// [BiometricType.MULTIPLE]
  /// [BiometricType.NONE]
  /// [BiometricType.NO_HARDWARE]
  /// [BiometricType.UNAVAILABLE]
  /// [BiometricType.UNSUPPORTED]
  static Future<BiometricType> get type async {
    return BiometricFingerprintPlatform.type;
  }

  static Future<bool> get isEnabled async {
    return BiometricFingerprintPlatform.isEnabled;
  }

  Future<BiometricResult> initAuthentication({
    required String biometricKey,
    required String message,
    String messageKey = '',
    String title = 'Biometric Authentication',
    String subtitle = 'Enter biometric credentials to proceed',
    String description = '',
    String negativeButtonText = 'CANCEL',
    bool confirmationRequired = false,
    bool deviceCredentialAllowed = false,
  }) {

    return BiometricFingerprintPlatform.initAuthentication(
      biometricKey: biometricKey,
        message: message,
      title: title,
      subtitle: subtitle,
      description: description,
      negativeButtonText: negativeButtonText,
      confirmationRequired: confirmationRequired,
      deviceCredentialAllowed: deviceCredentialAllowed,
    );
  }

}

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'biometric_fingerprint_platform_interface.dart';
import 'biometric_result.dart';

/// An implementation of [BiometricFingerprintPlatform] that uses method channels.
class MethodChannelBiometricFingerprint extends BiometricFingerprintPlatform {
  static const MethodChannel _channel = const MethodChannel('biometric_fingerprint');
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('biometric_fingerprint');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
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
    try {
      final String? type = await _channel.invokeMethod('type');

      print('Biometric type: $type');

      switch (type) {
        case 'FACE':
          return BiometricType.FACE;
        case 'FINGERPRINT':
          return BiometricType.FINGERPRINT;
        case 'IRIS':
          return BiometricType.IRIS;
        case 'MULTIPLE':
          return BiometricType.MULTIPLE;
        case 'NONE':
          return BiometricType.NONE;
        case 'NO_HARDWARE':
          return BiometricType.NO_HARDWARE;
        case 'UNAVAILABLE':
          return BiometricType.UNAVAILABLE;
        default:
          return BiometricType.UNSUPPORTED;
      }
    } on Exception {}

    return BiometricType.UNSUPPORTED;
  }

  /// Encrypt message using biometric.
  static Future<BiometricResult> initAuthentication({
    required String biometricKey,
    required String message,
    String messageKey = '',
    String title = 'Biometric Authentication',
    String subtitle = 'Enter biometric credentials to proceed',
    String description = '',
    String negativeButtonText = 'CANCEL',
    bool confirmationRequired = false,
    bool deviceCredentialAllowed = false,
  }) async {
    try {
      final resultKey = await _channel.invokeMethod('initAuthenticate', {
        'biometric_key': biometricKey,
        'message_key': messageKey,
        'message': message,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'negative_button_text': negativeButtonText,
        'confirmation_required': confirmationRequired,
        'device_credential_allowed': deviceCredentialAllowed,
      });

      print(resultKey);

      if (resultKey is String) {
        return BiometricResult(
          status: BiometricStatus.SUCCESS,
          data: resultKey,
        );
      } else {
        final bmType = await type;

        return BiometricResult(
          status: BiometricStatus.FAILED,
          type: bmType,
        );
      }
    } on Exception {
      return BiometricResult(status: BiometricStatus.CANCELED);
    }
  }
}

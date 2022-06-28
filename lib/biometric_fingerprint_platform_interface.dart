import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'biometric_fingerprint_method_channel.dart';
import 'biometric_result.dart';

abstract class BiometricFingerprintPlatform extends PlatformInterface {
  /// Constructs a BiometricFingerprintPlatform.
  BiometricFingerprintPlatform() : super(token: _token);

  static final Object _token = Object();

  static const MethodChannel _channel = const MethodChannel('biometric_fingerprint');

  static BiometricFingerprintPlatform _instance = MethodChannelBiometricFingerprint();

  /// The default instance of [BiometricFingerprintPlatform] to use.
  ///
  /// Defaults to [MethodChannelBiometricFingerprint].
  static BiometricFingerprintPlatform get instance => _instance;

  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BiometricFingerprintPlatform] when
  /// they register themselves.
  static set instance(BiometricFingerprintPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
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

      if (kDebugMode) {
        print('Biometric type: $type');
      }

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

  /// Returns true if device can use biometric.
  static Future<bool> get isEnabled async {
    try {
      final bmType = await type;

      return bmType == BiometricType.FACE ||
          bmType == BiometricType.FINGERPRINT ||
          bmType == BiometricType.IRIS ||
          bmType == BiometricType.MULTIPLE;
    } on Exception {
      return false;
    }
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

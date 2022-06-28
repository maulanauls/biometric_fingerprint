import 'package:flutter_test/flutter_test.dart';
import 'package:biometric_fingerprint/biometric_fingerprint.dart';
import 'package:biometric_fingerprint/biometric_fingerprint_platform_interface.dart';
import 'package:biometric_fingerprint/biometric_fingerprint_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBiometricFingerprintPlatform 
    with MockPlatformInterfaceMixin
    implements BiometricFingerprintPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BiometricFingerprintPlatform initialPlatform = BiometricFingerprintPlatform.instance;

  test('$MethodChannelBiometricFingerprint is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBiometricFingerprint>());
  });

  test('getPlatformVersion', () async {
    BiometricFingerprint biometricFingerprintPlugin = BiometricFingerprint();
    MockBiometricFingerprintPlatform fakePlatform = MockBiometricFingerprintPlatform();
    BiometricFingerprintPlatform.instance = fakePlatform;
  
    expect(await biometricFingerprintPlugin.getPlatformVersion(), '42');
  });
}

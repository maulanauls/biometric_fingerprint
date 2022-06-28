# biometric_fingerprint

A plugin for fingerprint dialog
BIOMETRIC FINGERPRINT
The easy way to use biometric authentication in your Flutter app.
Supports Fingerprint, FaceID and Iris.

## Getting Started

```
$ flutter pub add biometric_fingerprint
```

## Configuration

Change your android `MainActivity` to extends `FlutterFragmentActivity`.

```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

// kotlin
class MainActivity: FlutterFragmentActivity() {
  ...
}
```



```java
import io.flutter.embedding.android.FlutterFragmentActivity;

// java
class MainActivity extends FlutterFragmentActivity {
  ...
}
```

## Usage

To check biometric type of your device.

```dart
BiometricType type = await BiometricFingerprint.type;
```

Here is the list of biometric types.

```dart
BiometricType.FACE
BiometricType.FINGERPRINT
BiometricType.IRIS
BiometricType.MULTIPLE
BiometricType.NONE
BiometricType.NO_HARDWARE
BiometricType.UNAVAILABLE
BiometricType.UNSUPPORTED
```

To check if your device can use biometric authentication.

```dart
bool isBiometricEnabled = await BiometricFingerprint.isEnabled;
```

To using biometric authentication.


```dart
BiometricResult result = await BiometricFingerprint.initAuthentication({
  biometricKey: 'example_key',
  message: 'This is a very secret message',
  title: 'Biometric Encryption',
  subtitle: 'Enter biometric credentials to encrypt your message',
  description: 'Scan fingerprint or face.',
  negativeButtonText: 'USE PASSWORD',
  confirmationRequired: true,
});
```

```dart
if (result.isSuccess && result.hasData) {
  // result success example
  String messageKey = result.data!;
} else {
  showToast(result.errorMsg, context: context);
}
```




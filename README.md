# biometric_fingerprint

A plugin for fingerprint dialog
BIOMETRIC FINGERPRINT
The easy way to use biometric authentication in your Flutter app.
Supports Fingerprint, FaceID and Iris.


## Demo example

<table>
  <tr>
    <td><img src="https://github.com/maulanauls/biometric_fingerprint/raw/main/photo1656397022.jpeg" alt="example demo" width="200"></td>
    <td><img src="https://github.com/maulanauls/biometric_fingerprint/raw/main/photo1656397025.jpeg" alt="how example case" width="200"></td>
  </tr>
</table>

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

If you got issue in android 8 change in res/values/styles.xml to be like this

```xml

<style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
    <!--    <style name="LaunchTheme" parent="@style/Theme.AppCompat.Light">--> // comment this case
    <!-- Show a splash screen on the activity. Automatically removed when
         the Flutter engine draws its first frame -->
    <item name="android:windowBackground">@drawable/launch_background</item>
</style>

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




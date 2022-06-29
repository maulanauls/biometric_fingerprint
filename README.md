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
To show custom message in your biometric prompt, method encrypt and decrypt have parameters you can use to change the biometric prompt dialog.

```dart
BiometricResult result = await BiometricFingerprint.initAuthentication({
  biometricKey: 'example_key', // example paramter encrypt key
  message: 'This is a very secret message', // whatever you want description in dialog
  title: 'Biometric Encryption', // whatever you want to write the title
  subtitle: 'Enter biometric credentials to encrypt your message', // whatever you want to subtitle 
  description: 'Scan fingerprint or face.', // whatever you want description in dialog
  negativeButtonText: 'USE PASSWORD', // whatever you want make cancel can also "CANCEL"
  confirmationRequired: true, // confirmation 
});
```

```dart
if (result.isSuccess && result.hasData) {
  // result success example
  String messageKey = result.data!; // up to you make function to do login go head
  
} else {
  print(result.errorMsg);// showing error 
}
```


```dart
if (result.isFailed) {
 //failed case
}
```

```dart
if (result.isCanceled) {
 //if user cancel / close the dialog biometric or API has been closed
}
```

* Case use this plugin for
use case it will be up to you for using on it for login authentication for encrypt or decrypt data with biometric API.



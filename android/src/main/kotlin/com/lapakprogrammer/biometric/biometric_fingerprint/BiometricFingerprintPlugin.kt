package com.lapakprogrammer.biometric.biometric_fingerprint


import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import androidx.fragment.app.FragmentActivity
import androidx.annotation.NonNull
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import java.nio.charset.Charset
import javax.crypto.Cipher

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
/** BiometricFingerprintPlugin */
class BiometricFingerprintPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var activity: FragmentActivity? = null

  private lateinit var context: Context
  private lateinit var channel: MethodChannel
  private lateinit var cryptoManager: CryptoManager
  private lateinit var biometricHelper: BiometricFingerprintHelper
  private lateinit var biometricManager: BiometricManager
  private lateinit var biometricPrompt: BiometricPrompt
  private lateinit var promptInfo: BiometricPrompt.PromptInfo

  companion object {
    private const val TAG = "BiometricFingerprintPlugin"
    private const val SHARED_PREFS_NAME = "com.lapakprogrammer.biometric.biometric_fingerprint"
  }

  @SuppressLint("LongLogTag")
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "onAttachedToEngine")

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "biometric_fingerprint")
    channel.setMethodCallHandler(this)

    context = flutterPluginBinding.applicationContext

    cryptoManager = CryptoManager()
    biometricManager = BiometricManager.from(context)
    biometricHelper = BiometricFingerprintHelper(context)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "initAuthenticate" -> initAuthenticate(call, result)
      "initAutenticateType" -> checkType(result)
      else -> result.notImplemented()
    }
  }

  @SuppressLint("LongLogTag")
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "onDetachedFromEngine")
    channel.setMethodCallHandler(null)
  }

  @SuppressLint("LongLogTag")
  override fun onDetachedFromActivity() {
    Log.d(TAG, "onDetachedFromActivity")
  }

  @SuppressLint("LongLogTag")
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    Log.d(TAG, "onReattachedToActivityForConfigChanges")
  }

  @SuppressLint("LongLogTag")
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.d(TAG, "onAttachedToActivity")
    activity = binding.activity as FragmentActivity
  }

  @SuppressLint("LongLogTag")
  override fun onDetachedFromActivityForConfigChanges() {
    Log.d(TAG, "onDetachedFromActivityForConfigChanges")
  }


  private fun checkType(@NonNull result: Result) {
    val type = biometricHelper.biometricType()

    when (type) {
      BiometricType.FACE -> result.success("FACE")
      BiometricType.FINGERPRINT -> result.success("FINGERPRINT")
      BiometricType.IRIS -> result.success("IRIS")
      BiometricType.MULTIPLE -> result.success("MULTIPLE")
      BiometricType.NONE -> result.success("NONE")
      BiometricType.NO_HARDWARE -> result.success("NO_HARDWARE")
      BiometricType.UNAVAILABLE -> result.success("UNAVAILABLE")
      else -> result.success("UNSUPPORTED")
    }
  }


  @SuppressLint("LongLogTag")
  private fun initAuthenticate(@NonNull call: MethodCall, @NonNull result: Result) {
    val params = call.arguments as Map<*, *>
    val biometricKey = params["biometric_key"] as String
    val messageKey = params["message_key"] as String
    val message = params["message"] as String
    val title = params["title"] as String
    val subtitle = params["subtitle"] as String
    val description = params["description"] as String
    val negativeButtonText = params["negative_button_text"] as String
    val confirmationRequired = params["confirmation_required"] as Boolean
    val deviceCredentialAllowed = params["device_credential_allowed"] as Boolean

    Log.d(TAG, "biometric key " + biometricKey);
    Log.d(TAG, "message key " + biometricKey);

    try {
      val cipher = cryptoManager.getInitializedCipherForEncryption(biometricKey)
      val crypto = BiometricPrompt.CryptoObject(cipher)

      Log.d(TAG, "key crypto " + crypto);

      biometricHelper.showBiometricPrompt(
        activity!!,
        BiometricPromptInfo(
          title,
          subtitle,
          description,
          negativeButtonText,
          confirmationRequired,
          deviceCredentialAllowed
        ),
        crypto,
        { res ->
          res.cryptoObject?.cipher?.let { cipher ->
            val time = System.currentTimeMillis().toString()
            val resultKey = when {
              messageKey.isEmpty() -> "${biometricKey}_${time}"
              else -> messageKey
            }
            val ciphertext = cryptoManager.encryptData(message, cipher)

            cryptoManager.saveCiphertext(
              context,
              ciphertext,
              SHARED_PREFS_NAME,
              Context.MODE_PRIVATE,
              resultKey
            )

            result.success(resultKey)
          } ?: run {
            failed(result)
          }
        },
        { errCode, errString ->
          result.error(errCode.toString(), errString.toString(), null)
        },
        {
          Log.e(TAG, result.toString());
          failed(result)
        }
      )
    } catch (ex:Exception) {
      Log.e(TAG, result.toString());
      failed(result)
    }
  }

  @SuppressLint("LongLogTag")
  private fun failed(@NonNull result: Result) {
    Log.e(TAG, result.toString());
    result.error(
      "",
      "Authentication failed for an unknown reason",
      null
    )
  }
}

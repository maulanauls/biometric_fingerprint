import 'package:biometric_fingerprint/biometric_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:biometric_fingerprint/biometric_fingerprint.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _isAuthenticating = false;
  String _key = "";
  final _biometricFingerprintPlugin = BiometricFingerprint();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _biometricFingerprintPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  _success() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Yey, success to authenticate data key: ${_key}', style: const TextStyle(
                fontFamily: 'poppins',
                color: Colors.black,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
            content: Text('is authentication: ${_isAuthenticating}',style: const TextStyle(
                fontFamily: 'poppins',
                color: Colors.black,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close',style: const TextStyle(
                      fontFamily: 'poppins',
                      color: Colors.black,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      fontSize: 13))),
              TextButton(
                onPressed: () {
                  print(_isAuthenticating);
                  Navigator.pop(context);
                },
                child: Text('OK',style: const TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
              )
            ],
          );
        });
  }

  _error() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('OOps, error to authenticate data key: ${_key}', style: const TextStyle(
                fontFamily: 'poppins',
                color: Colors.black,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
            content: Text('is authentication: ${_isAuthenticating}',style: const TextStyle(
                fontFamily: 'poppins',
                color: Colors.black,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close',style: const TextStyle(
                      fontFamily: 'poppins',
                      color: Colors.black,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      fontSize: 13))),
              TextButton(
                onPressed: () {
                  print(_isAuthenticating);
                  Navigator.pop(context);
                },
                child: Text('OK',style: const TextStyle(
                    fontFamily: 'poppins',
                    color: Colors.black,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700,
                    fontSize: 13)),
              )
            ],
          );
        });
  }

  Future<void> _CallFingerPrint() async {
    setState(() {
      _isAuthenticating = false;
    });
    BiometricResult result =
        await _biometricFingerprintPlugin.initAuthentication(
      biometricKey: 'example',
      message: 'This is a very secret message',
      title: 'Biometric',
      subtitle: 'Enter biometric credentials example',
      description: 'Scan fingerprint.',
      negativeButtonText: 'CANCEL',
      confirmationRequired: true,
    );

    if (kDebugMode) {
      print(result.isSuccess);
    } // success
    if (kDebugMode) {
      print(result.isCanceled);
    } // cancel
    if (kDebugMode) {
      print(result.isFailed);
    } // failed

    if (result.isSuccess && result.hasData) {
      final key = result.data!;
      setState(() {
        _isAuthenticating = true;
        _key = key;
      });
      _success();
      return;
    }

    if (result.isFailed) {
      _error();
      setState(() {
        _key = result.errorMsg;
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BIOMETRIC EXAMPLE',
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'poppins',
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
              fontSize: 13),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 180,
            ),
            Center(
              child: IconButton(
                iconSize: 80,
                color: Colors.blue,
                icon: const Icon(Icons.fingerprint),
                tooltip: _isAuthenticating
                    ? 'Login with fingerprint'
                    : 'Authenticating....',
                onPressed: () {
                  _CallFingerPrint();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Try to press the icon fingerprint: $_platformVersion\n',
              style: const TextStyle(
                  fontFamily: 'poppins',
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'OS version: $_platformVersion\n',
              style: const TextStyle(
                  fontFamily: 'poppins',
                  color: Colors.black,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}

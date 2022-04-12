import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class FingerprintAuth{

  final LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometrics;
  late List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;


  Future<bool> checkBiometrics() async {
    print("_checkBiometrics called>>>>");
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      print("canCheckBiometrics>>>>"+canCheckBiometrics.toString());
      _canCheckBiometrics = canCheckBiometrics;
      if(canCheckBiometrics == true)
      {
        // getAvailableBiometrics();
      }
    } on PlatformException catch (e) {
      print(e);
    }

    return _canCheckBiometrics;

  }

  Future<String> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    String authType="";
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      // _authenticate();

      var val = BiometricType.values;
      print("val>>>"+val.toString());

      _availableBiometrics = availableBiometrics;

      if(_availableBiometrics.contains(BiometricType.face))
      {
        print("true for face");
        authType = "FaceEnabled";
      }
      else if(_availableBiometrics.contains(BiometricType.fingerprint))
      {
        print("true for fingerprint");
        authType = "FingerprintEnabled";
        /*authenticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Scan your fingerprint to authenticate',
            useErrorDialogs: true,
            stickyAuth: true);*/
      }
      else if(_availableBiometrics.contains(BiometricType.iris))
      {
        print("true for iris");
        authType = "IrisEnabled";
      }
      else
      {
        print("true for nothing");
        authType = "SecurityNotEnabled";
      }

    } on PlatformException catch (e) {
      print("PlatformException called>>>");
      print(e);
    }

    return authType;

  }


/*void cancelAuthentication() {
    auth.stopAuthentication();
  }*/


}

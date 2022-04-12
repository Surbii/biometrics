import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fingerprintAuth.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var biometricEnabledResult;
  var availableBiometric;
  final LocalAuthentication auth = LocalAuthentication();

  // FingerPrintAccCodeBloc _fingerprintAccCodeBloc;
  checkBiometrics() {
    var biometricResult = FingerprintAuth().checkBiometrics();
    biometricResult.then((value) {
      print("biometricEnabledResult from fingerprint auth>>>>" +
          value.toString());

      biometricEnabledResult = true;

      if (value == true) {
        var availableBiometricResult =
            FingerprintAuth().getAvailableBiometrics();
        availableBiometricResult.then((value1) {
          print("availableBiometricResult from fingerprint auth>>>>" +
              value1.toString());
          availableBiometric = value1;

          _authenticate(); //Show fingerprint popup.

          /* if(availableBiometric == "FaceEnabled" || availableBiometric == "FingerprintEnabled" || availableBiometric == "IrisEnabled")
          {
            _authenticate();
          }else{
            print("Security settings for device not enabled.");
          }*/
        });
      }
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          //authenticateWithBiometrics
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
    } on PlatformException catch (e) {
      print("PlatformException called in _authenticate()>>>");
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Material(
                  color: Colors.white,
                  child: Center(
                      child: Text(
                    message,
                    style: Theme.of(context).textTheme.headline3,
                  )),
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometric Demo"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                print(availableBiometric);
                if (availableBiometric == "FaceEnabled" ||
                    availableBiometric == "FingerprintEnabled" ||
                    availableBiometric == "IrisEnabled") {
                  _authenticate();
                } else {
                  print("Security settings for device not enabled.");
                }
              },
              child: const Text("Scan me"),
              color: Colors.redAccent,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

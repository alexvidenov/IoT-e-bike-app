import 'package:ble_app/main.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/loginPage.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:flutter/material.dart';

class _WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        ),
      );
}

class RootPage extends StatelessWidget {
  final Auth _auth;

  const RootPage(this._auth);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.authState,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return snapshot.hasData ? BleApp($()) : LoginScreen(_auth);
          } else
            return _WaitingScreen();
        });
  }
}

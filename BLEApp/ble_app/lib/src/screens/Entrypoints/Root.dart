import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/entryEndpointBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/LoginPage.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  final Auth _auth = locator<Auth>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          return isLoggedIn
              ? BleApp(locator<EntryEndpointBloc>())
              : LoginPage(_auth);
        }
        return _buildWaitingScreen();
      },
    );
  }

  Widget _buildWaitingScreen() {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

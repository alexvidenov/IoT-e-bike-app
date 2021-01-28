import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/entrypoints/WelcomeScreen.dart';
import 'package:ble_app/src/sealedStates/authState.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../authentication/authenticationWrapper.dart';
import '../../listeners/authStateListener.dart';
import 'Mode.dart';

class RootPage extends StatefulWidget {
  final AuthBloc _auth;
  final SettingsBloc _settingsBloc;

  const RootPage(this._auth, this._settingsBloc);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with AuthStateListener {
  AuthState currAuthState;

  bool isFirstTime = false;

  @override
  initState() {
    super.initState();
    widget._auth.setListener(this);
    if (widget._settingsBloc.isFirstTime()) isFirstTime = true;
  }

  void _chosen(Mode mode) {
    if (mode == Mode.Account)
      setState(() {
        isFirstTime = false;
        currAuthState =
            AuthState.loggedOut(); // TODO: fix this even tho it works
      });
    else if (mode == Mode.Incognito) {
      isFirstTime = false;
      widget._auth.signInAnonymously();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTime) {
      return Welcome(func: this._chosen);
    } else if (!isFirstTime) {
      if (currAuthState != null) {
        return currAuthState.maybeWhen(
            authenticated: (_) => BleApp($()),
            loggedOut: () => AuthenticationWrapper(widget._auth),
            orElse: () => Center(child: CircularProgressIndicator()));
      } else
        return Container();
    } else
      return Container();
  }

  @override
  onAuthStateChanged(AuthState authState) {
    print('STATE IS $authState');
    setState(() => currAuthState = authState);
  }

}

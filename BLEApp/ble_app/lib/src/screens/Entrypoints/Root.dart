import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/sealedStates/authState.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../authentication/authenticationWrapper.dart';
import '../../listeners/authStateListener.dart';

class RootPage extends StatefulWidget {
  final AuthBloc _auth;

  const RootPage(this._auth);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with AuthStateListener {
  AuthState currAuthState;

  @override
  initState() {
    super.initState();
    widget._auth.setListener(this);
  }

  @override
  Widget build(BuildContext context) {
    if (currAuthState != null) {
      return currAuthState.maybeWhen(
          authenticated: (_) => BleApp($()),
          loggedOut: () => AuthenticationWrapper(widget._auth),
          orElse: () => Container());
    } else
      return Container();
  }

  @override
  onAuthStateChanged(AuthState authState) =>
      setState(() => currAuthState = authState);
}

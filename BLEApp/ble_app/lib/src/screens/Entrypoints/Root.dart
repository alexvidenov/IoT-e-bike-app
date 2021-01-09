import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:flutter/material.dart';

import '../authentication/main.dart';
import '../authentication/authenticationWrapper.dart';
import '../../listeners/AuthStateListener.dart';

class RootPage extends StatefulWidget {
  final AuthBloc _auth;

  const RootPage(this._auth);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with AuthStateListener {
  bool get isLoggedIn => widget._auth.user != null ? true : false;

  @override
  void initState() {
    super.initState();
    widget._auth.setListener(this);
  }

  @override
  Widget build(BuildContext context) =>
      isLoggedIn ? BleApp($()) : AuthenticationWrapper(widget._auth);

  @override
  onFailure() => setState(() {});

  @override
  onSuccess() => setState(() {});
}

/*
StreamBuilder<AuthState>(
stream: widget._auth.authStream,
builder: (_, snapshot) {
if (snapshot.connectionState == ConnectionState.active) {
if (snapshot.hasData) {
Widget _widget;
snapshot.data.when(
authenticated: (auth) => _widget = BleApp($()),
notAuthenticated: (reason) =>
_widget = AuthenticationWrapper(widget._auth));
return _widget;
}
return WaitingScreen();
} else
return WaitingScreen();
});
 */

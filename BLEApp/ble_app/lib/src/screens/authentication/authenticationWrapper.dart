import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:ble_app/src/screens/authentication/loginPage.dart';
import 'package:ble_app/src/screens/authentication/registrationPage.dart';
import 'package:flutter/material.dart';

class AuthenticationWrapper extends StatefulWidget {
  final AuthBloc _authBloc;

  const AuthenticationWrapper(this._authBloc);

  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool isLogin = true;

  _toggleView() => setState(() => isLogin = !isLogin);

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginScreen(widget._authBloc, toggleView: _toggleView)
      : RegisterScreen(widget._authBloc, toggleView: _toggleView);
}

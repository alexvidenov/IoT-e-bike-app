import 'dart:async';

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/sealedStates/BTAuthState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class AuthenticationScreen extends StatefulWidget {
  final DeviceBloc _deviceBloc;
  final BluetoothAuthBloc _authBloc;
  final SettingsBloc _settingsBloc;

  const AuthenticationScreen(
      this._deviceBloc, this._authBloc, this._settingsBloc);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _writeController = TextEditingController();

  StreamSubscription<PeripheralConnectionState> _streamSubscriptionState;
  StreamSubscription<BTAuthState> _streamSubscriptionAuth;

  bool _isAuthenticated = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    widget._deviceBloc.init();
    widget._authBloc.create();
    widget._deviceBloc.connect().then((_) => _init());
  }

  _init() {
    _listenToAuthBloc();
    _listenToConnectBloc();
  }

  @override
  void dispose() {
    super.dispose();
    widget._deviceBloc.dispose();
    _streamSubscriptionState.cancel();
    _streamSubscriptionAuth.cancel();
  }

  _listenToConnectBloc() => _streamSubscriptionState =
          widget._deviceBloc.connectionState.listen((state) {
        if (state == PeripheralConnectionState.connected) {
          if (widget._settingsBloc.isPasswordRemembered() == true) {
            widget._deviceBloc.deviceReady.listen((event) {
              if (event == true) {
                widget._authBloc
                    .authenticate(widget._settingsBloc.getPassword());
              }
            });
          } else
            _presentDialog(context,
                message: 'Enter your password', action: 'Send');
        }
      });

  _listenToAuthBloc() =>
      _streamSubscriptionAuth = widget._authBloc.stream.listen((event) {
        event.when(
            bTAuthenticated: () {
              _isAuthenticated = true;
              Navigator.of(context).pushNamed('/home');
            },
            bTNotAuthenticated: (reason) => null);
      });

  // this retry will be in the bloc
  _retry() => Future.delayed(Duration(seconds: 4), () {
        if (_isAuthenticated == false)
          _presentDialog(context,
              message: 'Wrong password', action: 'Try again');
      });

  Future<void> _presentDialog(BuildContext widgetContext,
      {String message, String action}) async {
    await showDialog(
      context: widgetContext,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: TextField(
          controller: _writeController,
          onChanged: widget._settingsBloc.setPassword,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(action),
            onPressed: () {
              widget._authBloc.authenticate(_writeController.value.text);
              _retry();
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }

  Widget _generateMessageWidget(String message) => Center(
      child: Text(message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'Europe_Ext',
          )));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: Colors.black,
          child: StreamBuilder<PeripheralConnectionState>(
            stream: widget._deviceBloc.connectionState,
            initialData: PeripheralConnectionState.disconnected,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                switch (snapshot.data) {
                  case PeripheralConnectionState.connected:
                    return _generateMessageWidget('Connected');
                  case PeripheralConnectionState.connecting:
                    return Center(child: CircularProgressIndicator());
                  case PeripheralConnectionState.disconnected:
                    return _generateMessageWidget('disconnected');
                  case PeripheralConnectionState.disconnecting:
                    return _generateMessageWidget('disconnecting');
                }
              } else
                return Center(child: CircularProgressIndicator());
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      );
}

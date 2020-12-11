import 'dart:async';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/modules/sealedAuthStates/BTAuthState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

// ignore: must_be_immutable
class AuthenticationScreen extends RouteAwareWidget<BluetoothAuthBloc> {
  final DeviceBloc _deviceBloc;
  final BluetoothAuthBloc _authBloc;
  final SettingsBloc _settingsBloc;

  final _writeController = TextEditingController();

  StreamSubscription<PeripheralConnectionState> _streamSubscriptionState;
  StreamSubscription<BTAuthState> _streamSubscriptionAuth;

  bool _isAuthenticated = false;

  AuthenticationScreen(
      this._deviceBloc, BluetoothAuthBloc _authBloc, this._settingsBloc)
      : this._authBloc = _authBloc,
        super(bloc: _authBloc);

  @override
  onCreate() {
    super.onCreate();
    _deviceBloc.init();
    // TO AVOID CONFLICTS WITH DIDCHANGE DEPENDENCIES, CALL THE CONNECT NOT FROM HERE
    _deviceBloc.connect();
  }

  _init(context) {
    _listenToAuthBloc(context);
    _listenToConnectBloc(context);
  }

  _listenToConnectBloc(context) =>
      _streamSubscriptionState = _deviceBloc.connectionState.listen((state) {
        if (state == PeripheralConnectionState.connected) {
          if (_settingsBloc.isPasswordRemembered() == true) {
            _deviceBloc.deviceReady.listen((event) {
              if (event == true) {
                _authBloc.authenticate(_settingsBloc.getPassword());
              }
            });
          } else {
            _presentDialog(context);
          }
        }
      });

  _listenToAuthBloc(context) =>
      _streamSubscriptionAuth = _authBloc.stream.listen((event) {
        event.continued((authenticated) {
          _isAuthenticated = true;
          Navigator.of(context).pushNamed('/home');
          // TODO: present Dialog in this case with the specific message
        }, (notAuthenticated) => null);
      });

  _retry(context) => Future.delayed(Duration(seconds: 4), () {
        if (_isAuthenticated == false) {
          _presentDialog(context);
        }
      });

  Future<void> _presentDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter your password"),
        content: TextField(
          controller: _writeController,
          onChanged: _settingsBloc.setPassword,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Send"),
            onPressed: () {
              _authBloc.authenticate(_writeController.value.text);
              _retry(context);
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
  Widget buildWidget(BuildContext context) {
    _init(context);
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: StreamBuilder<PeripheralConnectionState>(
          stream: _deviceBloc.connectionState,
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
            return Container();
          },
        ),
      ),
    );
  }

  @override
  onDestroy() {
    super.onDestroy();
    _deviceBloc.dispose();
    _streamSubscriptionState.cancel();
    _streamSubscriptionAuth.cancel();
  }
}

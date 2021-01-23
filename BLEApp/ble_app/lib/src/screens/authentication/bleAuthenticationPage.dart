import 'dart:async';

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/screens/parameterFetchScreen.dart';
import 'package:ble_app/src/sealedStates/btAuthState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class BLEAuthenticationScreen extends StatefulWidget {
  final DeviceBloc _deviceBloc;
  final BluetoothAuthBloc _authBloc;
  final SettingsBloc _settingsBloc;
  final LocalDatabase _localDatabase;

  const BLEAuthenticationScreen(this._deviceBloc, this._authBloc,
      this._settingsBloc, this._localDatabase);

  @override
  _BLEAuthenticationScreenState createState() =>
      _BLEAuthenticationScreenState();
}

class _BLEAuthenticationScreenState extends State<BLEAuthenticationScreen> {
  final _writeController = TextEditingController();

  StreamSubscription<PeripheralConnectionState> _streamSubscriptionState;
  StreamSubscription<BTAuthState> _streamSubscriptionAuth;

  bool _isAuthenticated = false;

  bool _connected = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    widget._deviceBloc.init();
    widget._authBloc.create();
    widget._deviceBloc.connect().then((_) => _init());
    //_handleBLEError();
  }

  _init() {
    _listenToAuthBloc();
    _listenToConnectBloc();
  }

  //_handleBLEError() => Future.delayed(Duration(seconds: 4), () {
  // // TODO: extract in some handlers object
  // if (!_connected) widget._deviceBloc.connect();
  // });

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
          _connected = true;
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
            btAuthenticated: () {
              BleDevice device = widget._deviceBloc.device.value;
              widget._localDatabase.deviceDao
                  .setMacAddress(device.id, '1234567');
              _isAuthenticated = true;
              //Navigator.of(context).pushReplacementNamed('/home');
              Navigator.of(context).pushReplacementNamed('/fetchParameters');
            },
            failedToBTAuthenticate: (reason) => _presentDialog(context,
                message: reason.toString(), action: 'TRY AGAIN'));
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
      barrierDismissible: false,
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
  Widget build(BuildContext context) {
    return Scaffold(
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
            return Container();
          },
        ),
      ),
    );
  }
}

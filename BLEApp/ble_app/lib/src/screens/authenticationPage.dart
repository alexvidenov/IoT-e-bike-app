import 'dart:async';

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:ble_app/src/screens/shortStatusPage.dart';
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
  StreamSubscription<bool> _streamSubscriptionAuth;

  bool _isAuthenticated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget._deviceBloc.init();
    widget._deviceBloc.connect().then((_) => _init());
  }

  _init() {
    _listenToAuthBloc();
    _listenToConnectBloc();
  }

  @override
  void dispose() {
    super.dispose();
    widget._deviceBloc.disconnect();
    widget._deviceBloc.dispose();
  }

  _listenToConnectBloc() {
    _streamSubscriptionState =
        widget._deviceBloc.connectionState.listen((event) {
      if (event == PeripheralConnectionState.connected) {
        if (widget._settingsBloc.isPasswordRemembered() == true) {
          widget._deviceBloc.deviceReady.listen((event) {
            if (event == true) {
              widget._authBloc.authenticate(widget._settingsBloc.getPassword());
            }
          });
        } else {
          _presentDialog(context);
        }
      }
    });
  }

  _listenToAuthBloc() {
    _streamSubscriptionAuth = widget._authBloc.stream.listen((event) {
      if (event == true) {
        _isAuthenticated = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    HomeScreen(widget._settingsBloc, widget._deviceBloc)));
        //_authBloc.dispose();
        //_streamSubscriptionState.cancel();
        //_streamSubscriptionAuth.cancel();
      }
    });
  }

  _retry() => Future.delayed(Duration(seconds: 4), () {
        if (_isAuthenticated == false) {
          _presentDialog(context);
        }
      });

  Future<void> _presentDialog(BuildContext widgetContext) async {
    await showDialog(
      context: widgetContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter your password"),
          content: TextField(
            controller: _writeController,
            onChanged: widget._settingsBloc.setPassword,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Send"),
              onPressed: () {
                widget._authBloc.authenticate(_writeController.value.text);
                _retry();
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Are you sure?',
                  style: TextStyle(fontFamily: 'Europe_Ext')),
              content: Text('Do you want to disconnect device and go back?',
                  style: TextStyle(fontFamily: 'Europe_Ext')),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
                FlatButton(
                    onPressed: () {
                      widget._deviceBloc.disconnect();
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes')),
              ],
            ) ??
            false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: StreamBuilder<PeripheralConnectionState>(
            stream: widget._deviceBloc.connectionState,
            initialData: PeripheralConnectionState.disconnected,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                switch (snapshot.data) {
                  case PeripheralConnectionState.connected:
                    return Container(
                      color: Colors.black,
                      child: Center(
                        child: Text("Connected",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Europe_Ext',
                            )),
                      ),
                    );
                  case PeripheralConnectionState.connecting:
                    return Center(child: CircularProgressIndicator());
                  case PeripheralConnectionState.disconnected:
                    return Center(
                      child: Text("Disconnected",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Europe_Ext',
                          )),
                    );
                  case PeripheralConnectionState.disconnecting:
                    break; // think what to do here
                }
              } else
                return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

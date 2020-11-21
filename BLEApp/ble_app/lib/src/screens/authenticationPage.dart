import 'dart:async';

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:get_it/get_it.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  DeviceBloc _deviceBloc;
  BluetoothAuthBloc _authBloc;
  SettingsBloc _settingsBloc;
  final _writeController = TextEditingController();

  StreamSubscription<PeripheralConnectionState> _streamSubscriptionState;
  StreamSubscription<bool> _streamSubscriptionAuth;

  bool _isAuthenticated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceBloc = GetIt.I<DeviceBloc>();
    _settingsBloc = GetIt.I<SettingsBloc>();
    _deviceBloc.init();
    _authBloc = GetIt.I<BluetoothAuthBloc>();
    _deviceBloc.connect().then((_) => _init());
  }

  _init() {
    _listenToAuthBloc();
    _listenToConnectBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _deviceBloc.disconnect();
    _deviceBloc.dispose();
  }

  _listenToConnectBloc() {
    _streamSubscriptionState = _deviceBloc.connectionState.listen((event) {
      if (event == PeripheralConnectionState.connected) {
        if (_settingsBloc.isPasswordRemembered() == true) {
          _deviceBloc.deviceReady.listen((event) {
            print('dddddddddoooooooooooooooooooooooddddddddddddddddd: ' +
                _settingsBloc.getPassword());
            if (event == true) {
              GetIt.I<BluetoothAuthBloc>()
                  .authenticate(_settingsBloc.getPassword());
            }
          });
          //print('dooooooooooooood' + _settingsBloc.getPassword());
        } else {
          _presentDialog(context);
        }
      }
    });
  }

  _listenToAuthBloc() {
    _streamSubscriptionAuth = _authBloc.stream.listen((event) {
      if (event == true) {
        _isAuthenticated = true;
        GetIt.I<BluetoothAuthBloc>().dispose();
        _streamSubscriptionState.cancel();
        _streamSubscriptionAuth.cancel();
        // later on have a method here that nullifies the characteristic's value
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    });
  }

  _retry() {
    Future.delayed(Duration(seconds: 4), () {
      if (_isAuthenticated == false) {
        _presentDialog(context);
      }
    });
  }

  Future<void> _presentDialog(BuildContext widgetContext) async {
    final settingsBloc = GetIt.I<SettingsBloc>();
    await showDialog(
      context: widgetContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter your password"),
          content: TextField(
            controller: _writeController,
            onChanged: settingsBloc.setPassword,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Send"),
              onPressed: () {
                GetIt.I<BluetoothAuthBloc>()
                    .authenticate(_writeController.value.text);
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
                      _deviceBloc.disconnect();
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
            stream: _deviceBloc.connectionState,
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

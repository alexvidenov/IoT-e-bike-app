import 'dart:async';

import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class DisconnectedPage extends StatefulWidget {
  @override
  _DisconnectedPageState createState() => _DisconnectedPageState();
}

class _DisconnectedPageState extends State<DisconnectedPage> {
  final DeviceBloc _deviceBloc = locator<DeviceBloc>();

  final SettingsBloc _settingsBloc = locator<SettingsBloc>();

  StreamSubscription<bool> _stateSubscription;

  StreamSubscription<PeripheralConnectionState> _connectionSubscription;

  _onPause() {
    _stateSubscription.cancel();
    _connectionSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    _connectionSubscription = _deviceBloc.connectionState.listen((event) {
      if (event == PeripheralConnectionState.connected) {
        _stateSubscription = _deviceBloc.deviceReady.listen((event) {
          if (event == true) {
            DeviceRepository()
                .writeToCharacteristic(_settingsBloc.password.value);
            _onPause();
            Navigator.of(context).pop();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Disconnected',
              style: TextStyle(
                  fontSize: 20, color: Colors.white, letterSpacing: 2),
            ),
            centerTitle: true),
        body: Container(
            color: Colors.black,
            child: Center(
                child: RaisedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: () async => await _deviceBloc.connect(),
                    child: Text('Reconnect',
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            letterSpacing: 2))))));
  }
}

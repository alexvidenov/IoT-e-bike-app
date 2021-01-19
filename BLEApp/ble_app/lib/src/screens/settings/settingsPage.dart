import 'dart:async';

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:flutter/material.dart';

enum ConnectionSettings { Manual, AutoConnect, AutoPassword }

// ignore: must_be_immutable
class ConnectionSettingsScreen extends StatelessWidget {
  final DeviceRepository _deviceRepository;
  final BluetoothAuthBloc _authBloc;
  final SettingsBloc _settingsBloc;

  final _writeController = TextEditingController();

  ConnectionSettings _connectionSettings;

  ConnectionSettingsScreen(this._deviceRepository, this._settingsBloc, this._authBloc) {
    _listenToConnectionSettingsChanges();
    if (_settingsBloc.isPasswordRemembered())
      _connectionSettings = ConnectionSettings.AutoPassword;
    else if (_settingsBloc.isDeviceRemembered())
      _connectionSettings = ConnectionSettings.AutoConnect;
    else
      _connectionSettings = ConnectionSettings.Manual;
  }

  _listenToConnectionSettingsChanges() =>
      _settingsBloc.connectionSettingsChanged
          .listen((event) => _connectionSettings = event);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            'Settings',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.lock_outline, color: Colors.black),
                    title: Text("Change password"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _presentDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text("Connection Settings: ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
            _generateListTileStreamBuilder(
                value: ConnectionSettings.Manual,
                title: 'Manual',
                onChanged: (_) => _settingsBloc.setManual(),
                secondary: Icon(Icons.security)),
            _generateListTileStreamBuilder(
                value: ConnectionSettings.AutoConnect,
                title: 'Auto connect',
                onChanged: (_) => _settingsBloc
                    .setAutoConnect(_deviceRepository.pickedDevice.value.id),
                secondary: Icon(Icons.bluetooth_connected)),
            _generateListTileStreamBuilder(
              value: ConnectionSettings.AutoPassword,
              title: 'Remember my password',
              onChanged: (_) => _settingsBloc
                  .setAutoPassword(_deviceRepository.pickedDevice.value.id),
            ),
          ],
        ),
      );

  Widget _generateListTileStreamBuilder(
          {@required ConnectionSettings value,
          @required String title,
          @required Function onChanged,
          Widget secondary}) =>
      StreamBuilder(
        stream: _settingsBloc.connectionSettingsChanged,
        builder: (_, __) => RadioListTile<ConnectionSettings>(
          activeColor: Colors.lightBlueAccent,
          secondary: secondary ?? null,
          value: value,
          title: Text(title),
          onChanged: onChanged,
          groupValue: _connectionSettings,
        ),
      );

  Future<void> _presentDialog(BuildContext widgetContext) async {
    await showDialog(
      context: widgetContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Change your password"),
          content: TextField(
            controller: _writeController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Confirm"),
              onPressed: () {
                // same mechanism for resrtting password (should get latest one) and listen and stuff..
                _authBloc.changePassword(_writeController.value.text);
                _settingsBloc.setPassword(_writeController.value.text);
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}

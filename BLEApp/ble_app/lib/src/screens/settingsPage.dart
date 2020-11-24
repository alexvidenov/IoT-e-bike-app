import 'dart:async';

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:flutter/material.dart';

enum ConnectionSettings { Manual, AutoConnect, AutoPassword }

// ignore: must_be_immutable
class Settings extends StatelessWidget {
  final DeviceRepository deviceRepository = DeviceRepository();
  final SettingsBloc settingsBloc = locator<SettingsBloc>();

  final _writeController = TextEditingController();

  ConnectionSettings _connectionSettings;

  Settings() {
    _listenToConnectionSettingsChanges();
    if (settingsBloc.isPasswordRemembered())
      _connectionSettings = ConnectionSettings.AutoPassword;
    else if (settingsBloc.isDeviceRemembered())
      _connectionSettings = ConnectionSettings.AutoConnect;
    else
      _connectionSettings = ConnectionSettings.Manual;
  }

  _listenToConnectionSettingsChanges() => settingsBloc.connectionSettingsChanged
      .listen((event) => _connectionSettings = event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text("Device Settings: ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
            StreamBuilder<ConnectionSettings>(
                stream: settingsBloc.connectionSettingsChanged,
                builder: (_, __) {
                  return RadioListTile<ConnectionSettings>(
                    activeColor: Colors.lightBlueAccent,
                    value: ConnectionSettings.Manual,
                    title: Text("Manual"),
                    onChanged: (_) => settingsBloc.setManual(),
                    groupValue: _connectionSettings,
                  );
                }),
            StreamBuilder<ConnectionSettings>(
                stream: settingsBloc.connectionSettingsChanged,
                builder: (_, __) {
                  return RadioListTile<ConnectionSettings>(
                    secondary: Icon(Icons.settings_bluetooth),
                    activeColor: Colors.lightBlueAccent,
                    value: ConnectionSettings.AutoConnect,
                    title: Text("Auto connect"),
                    onChanged: (_) => settingsBloc
                        .setAutoconnect(deviceRepository.pickedDevice.value.id),
                    groupValue: _connectionSettings,
                  );
                }),
            StreamBuilder<ConnectionSettings>(
                stream: settingsBloc.connectionSettingsChanged,
                builder: (_, __) {
                  return RadioListTile<ConnectionSettings>(
                    activeColor: Colors.lightBlueAccent,
                    secondary: Icon(Icons.security),
                    value: ConnectionSettings.AutoPassword,
                    groupValue: _connectionSettings,
                    title: Text("Remember my password"),
                    onChanged: (_) => settingsBloc.setAutoPassword(
                        deviceRepository.pickedDevice.value.id),
                  );
                }),
          ],
        ),
      ),
    );
  }

  // for future use
  Widget _generateListTileStreamBuilder(
          {@required ConnectionSettings value,
          @required String title,
          @required Function onChanged,
          Widget secondary}) =>
      StreamBuilder(
        stream: settingsBloc.connectionSettingsChanged,
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
                locator<BluetoothAuthBloc>()
                    .changePassword(_writeController.value.text);
                settingsBloc.setPassword(_writeController.value.text);
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}

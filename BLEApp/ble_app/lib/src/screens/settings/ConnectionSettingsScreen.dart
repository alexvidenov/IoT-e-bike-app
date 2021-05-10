import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/screens/base/BaseSettingScreen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConnectionSettingsScreen extends BaseSettingScreen {
  ConnectionSettings _connectionSettings;

  ConnectionSettingsScreen() : super(title: "Connection settings") {
    _listenToConnectionSettingsChanges();
    if (settingsBloc.isPasswordRemembered())
      _connectionSettings = ConnectionSettings.AutoPassword;
    else if (settingsBloc.isDeviceRemembered())
      _connectionSettings = ConnectionSettings.AutoConnect;
    else
      _connectionSettings = ConnectionSettings.Manual;
  }

  void _listenToConnectionSettingsChanges() =>
      settingsBloc.connectionSettingsChanged
          .listen((event) => _connectionSettings = event);

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

  @override
  Widget buildContent(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _generateListTileStreamBuilder(
              value: ConnectionSettings.Manual,
              title: 'Manual',
              onChanged: (_) => settingsBloc.setManual(),
              secondary: Icon(Icons.security)),
          _generateListTileStreamBuilder(
              value: ConnectionSettings.AutoConnect,
              title: 'Auto connect',
              onChanged: (_) => settingsBloc
                  .setAutoConnect(deviceRepository.pickedDevice.value.id),
              secondary: Icon(Icons.bluetooth_connected)),
          _generateListTileStreamBuilder(
            value: ConnectionSettings.AutoPassword,
            title: 'Remember my PIN code',
            onChanged: (_) => settingsBloc
                .setAutoPassword(deviceRepository.pickedDevice.value.id),
          ),
        ],
      );
}

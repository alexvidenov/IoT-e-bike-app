import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/base/KeepAliveWidget.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/prefs/settingsBloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';

abstract class BaseSettingScreen extends KeepAliveWidget {
  final DeviceRepository deviceRepository = $<DeviceRepository>();
  final BluetoothAuthBloc bluetoothAuthBloc = $<BluetoothAuthBloc>();
  final SettingsBloc settingsBloc = $<SettingsBloc>();

  final String title;

  BaseSettingScreen({this.title});

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            '${title}',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text('${title} :',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
            buildContent(context),
          ],
        ),
      );

  Widget buildContent(BuildContext context);
}

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/data/DeviceRepository.dart';
import 'package:ble_app/src/screens/devicesListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

void main() {
  GetIt.I.allowReassignment = true; // false in prod
  GetIt.I.registerLazySingleton(() => ShortStatusBloc());
  GetIt.I.registerLazySingleton(() => FullStatusBloc());
  GetIt.I.registerLazySingleton(() => BluetoothAuthBloc());
  GetIt.I.registerLazySingleton(() => LocationBloc());
  GetIt.I.registerLazySingleton(
    () => DeviceRepository(),
  );
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.lightBlue,
        theme: ThemeData(fontFamily: 'Europe_Ext'),
        home: Provider(
          lazy: false,
          create: (_) => DevicesBloc(DeviceRepository(), BleManager()),
          child: DevicesListScreen(),
        ));
  }
}
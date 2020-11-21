import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/blocs/sharedPrefsBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/screens/authenticationPage.dart';
import 'package:ble_app/src/screens/devicesListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:get_it/get_it.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.allowReassignment = true; // false in prod
  GetIt.I.registerLazySingleton(() => ShortStatusBloc());
  GetIt.I.registerLazySingleton(() => FullStatusBloc());
  GetIt.I.registerLazySingleton(() => BluetoothAuthBloc());
  GetIt.I.registerLazySingleton(() => LocationBloc());
  GetIt.I.registerLazySingleton(() => SettingsBloc());
  GetIt.I.registerLazySingleton(
      () => DevicesBloc(DeviceRepository(), BleManager()));
  GetIt.I.registerLazySingleton(
      () => DeviceBloc(DeviceRepository(), BleManager()));
  GetIt.I.registerLazySingleton(
    () => DeviceRepository(),
  );
  setupSharedPrefs()
      .then((_) => BleManager()
          .createClient(restoreStateIdentifier: "com.example.ble_app"))
      .then((_) => runApp(BleApp()));
}

Future<void> setupSharedPrefs() => SharedPrefsService.getInstance()
    .then((settingsBloc) => GetIt.I.registerSingleton(settingsBloc));

class BleApp extends StatelessWidget {
  final prefsBloc = GetIt.I<SharedPrefsService>();

  @override
  Widget build(BuildContext context) {
    String result = prefsBloc.getOptionalDevice();
    if (result != 'empty') {
      BleDevice device =
          BleDevice(peripheral: BleManager().createUnsafePeripheral(result));
      final devicesBloc = GetIt.I<DevicesBloc>();
      devicesBloc.init();
      devicesBloc.devicePicker.add(device);
      return StreamBuilder(
        stream: devicesBloc.pickedDevice,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            return MaterialApp(
                color: Colors.lightBlue,
                theme: ThemeData(fontFamily: 'Europe_Ext'),
                home: AuthenticationScreen());
          } else
            return Container();
        },
      );
    } else {
      return MaterialApp(
          color: Colors.lightBlue,
          theme: ThemeData(fontFamily: 'Europe_Ext'),
          home: DevicesListScreen());
    }
  }
}

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/blocs/sharedPrefsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/screens/authenticationPage.dart';
import 'package:ble_app/src/screens/devicesListScreen.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDependencies();
  runApp(BleApp(prefsBloc: locator<SharedPrefsService>()));
}

class BleApp extends StatelessWidget {
  final SharedPrefsService prefsBloc;

  const BleApp({@required this.prefsBloc});

  @override
  Widget build(BuildContext context) {
    String result = prefsBloc.getOptionalDevice();
    if (result != 'empty') {
      BleDevice device =
          BleDevice(peripheral: BleManager().createUnsafePeripheral(result));
      final devicesBloc = locator<DevicesBloc>();
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
                home: AuthenticationScreen(locator<DeviceBloc>(),
                    locator<BluetoothAuthBloc>(), locator<SettingsBloc>()));
          } else
            return Container();
        },
      );
    } else {
      return MaterialApp(
        color: Colors.lightBlue,
        theme: ThemeData(fontFamily: 'Europe_Ext'),
        home: DevicesListScreen(locator<DevicesBloc>()),
      );
    }
  }
}

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/entryEndpointBloc.dart';
import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/navigationService.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/blocs/sharedPrefsBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setUpDependencies() async {
  final _deviceRepository = DeviceRepository();
  final _bleManager = BleManager();
  final _navigationService = NavigationService();
  locator.registerLazySingleton(() => Auth());
  locator.registerLazySingleton(() => EntryEndpointBloc());
  locator.registerFactory(() => ShortStatusBloc(_deviceRepository));
  locator.registerFactory(() => FullStatusBloc(_deviceRepository));
  locator.registerFactory(() => BluetoothAuthBloc(_deviceRepository));
  locator.registerFactory(() => LocationBloc());
  locator.registerLazySingleton(() => SettingsBloc());
  locator.registerFactory(() => DevicesBloc(_bleManager, _deviceRepository));
  locator
      .registerLazySingleton(() => DeviceBloc(_bleManager, _deviceRepository));
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => NavigationBloc(_navigationService));
  await SharedPrefsService.getInstance()
      .then((settingsBloc) => locator.registerSingleton(settingsBloc))
      .then((_) => BleManager()
          .createClient(restoreStateIdentifier: "com.example.ble_app"));
}

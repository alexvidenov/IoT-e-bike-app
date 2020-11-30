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

final sl = GetIt.instance;

Future<void> setUpDependencies() async {
  sl.registerSingleton(DeviceRepository());
  sl.registerSingleton(BleManager());
  sl.registerSingleton(NavigationService());
  sl.registerLazySingleton(() => Auth());
  sl.registerLazySingleton(() => EntryEndpointBloc());
  sl.registerFactory(() => ShortStatusBloc(sl()));
  sl.registerFactory(() => FullStatusBloc(sl()));
  sl.registerFactory(() => BluetoothAuthBloc(sl()));
  sl.registerFactory(() => LocationBloc());
  sl.registerFactory(() => DevicesBloc(sl(), sl()));
  sl.registerLazySingleton(() => SettingsBloc(sl()));
  sl.registerLazySingleton(() => DeviceBloc(sl(), sl()));
  sl.registerLazySingleton(() => NavigationBloc(sl()));
  sl.registerSingletonAsync(() => SharedPrefsService.getInstance());
}

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/navigationService.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/blocs/sharedPrefsBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setUpDependencies() async {
  final _repository = DeviceRepository();
  final _bleManager = BleManager();
  locator.registerFactory(() => ShortStatusBloc(_repository));
  locator.registerFactory(() => FullStatusBloc(_repository));
  locator.registerLazySingleton(() => BluetoothAuthBloc(_repository));
  locator.registerFactory(() => LocationBloc());
  locator.registerLazySingleton(() => SettingsBloc());
  locator.registerLazySingleton(() => DevicesBloc(_bleManager, _repository));
  locator.registerLazySingleton(() => DeviceBloc(_bleManager, _repository));
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => NavigationBloc());
  await SharedPrefsService.getInstance()
      .then((settingsBloc) => locator.registerSingleton(settingsBloc))
      .then((_) => BleManager()
          .createClient(restoreStateIdentifier: "com.example.ble_app"));
}

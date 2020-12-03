// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../services/Auth.dart';
import '../blocs/btAuthenticationBloc.dart';
import '../blocs/deviceBloc.dart';
import '../model/DeviceRepository.dart';
import '../blocs/devicesBloc.dart';
import '../blocs/entryEndpointBloc.dart';
import '../blocs/fullStatusBloc.dart';
import '../blocs/locationBloc.dart';
import '../blocs/navigationBloc.dart';
import '../blocs/navigationService.dart';
import '../blocs/settingsBloc.dart';
import '../blocs/sharedPrefsBloc.dart';
import '../blocs/shortStatusBloc.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<Auth>(() => Auth());
  gh.lazySingleton<DeviceRepository>(() => DeviceRepository());
  gh.factory<DevicesBloc>(() => DevicesBloc(get<DeviceRepository>()));
  gh.factory<FullStatusBloc>(() => FullStatusBloc(get<DeviceRepository>()));
  gh.factory<LocationBloc>(() => LocationBloc());
  gh.lazySingleton<NavigationService>(() => NavigationService());
  gh.factory<ShortStatusBloc>(() => ShortStatusBloc(get<DeviceRepository>()));
  gh.factory<BluetoothAuthBloc>(
      () => BluetoothAuthBloc(get<DeviceRepository>()));
  gh.lazySingleton<DeviceBloc>(() => DeviceBloc(get<DeviceRepository>()));
  gh.lazySingleton<NavigationBloc>(
      () => NavigationBloc(get<NavigationService>()));
  gh.lazySingleton<SettingsBloc>(() => SettingsBloc(get<SharedPrefsService>()));
  gh.lazySingleton<EntryEndpointBloc>(
      () => EntryEndpointBloc(get<DevicesBloc>(), get<SettingsBloc>()));

  // Eager singletons must be registered in the right order
  gh.singletonAsync<SharedPrefsService>(() => SharedPrefsService.getInstance());
  return get;
}

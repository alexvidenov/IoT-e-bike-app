// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../services/Auth.dart';
import '../blocs/authBloc.dart';
import '../blocs/btAuthenticationBloc.dart';
import '../services/CloudMessaging.dart';
import '../blocs/deviceBloc.dart';
import '../repositories/DeviceRepository.dart';
import '../blocs/devicesBloc.dart';
import '../blocs/entryEndpointBloc.dart';
import '../blocs/fullStatusBloc.dart';
import '../persistence/localDatabase.dart';
import '../persistence/LocalDatabaseManager.dart';
import '../blocs/locationBloc.dart';
import '../blocs/navigationBloc.dart';
import '../blocs/navigationService.dart';
import '../blocs/OutputControlBloc.dart';
import '../blocs/PageManager.dart';
import '../blocs/parameterFetchBloc.dart';
import '../blocs/mixins/parameterAware/ParameterHolder.dart';
import '../blocs/parameterListenerBloc.dart';
import '../blocs/settingsBloc.dart';
import '../blocs/sharedPrefsService.dart';
import '../blocs/shortStatusBloc.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<CloudMessaging>(() => CloudMessaging());
  gh.lazySingleton<DeviceRepository>(() => DeviceRepository());
  gh.factory<FullStatusBloc>(() => FullStatusBloc(get<DeviceRepository>()));
  gh.lazySingleton<LocalDatabaseManager>(
      () => LocalDatabaseManager(get<LocalDatabase>()));
  gh.factory<LocationBloc>(() => LocationBloc());
  gh.lazySingleton<NavigationService>(() => NavigationService());
  gh.factory<OutputControlBloc>(
      () => OutputControlBloc(get<DeviceRepository>()));
  gh.lazySingleton<PageManager>(() => PageManager());
  gh.lazySingleton<ParameterHolder>(() => ParameterHolder());
  gh.factory<ParameterListenerBloc>(() => ParameterListenerBloc(
        get<DeviceRepository>(),
        get<ParameterHolder>(),
        get<LocalDatabaseManager>(),
      ));
  gh.factory<ShortStatusBloc>(() => ShortStatusBloc(get<DeviceRepository>()));
  gh.lazySingleton<Auth>(() => Auth(get<LocalDatabaseManager>()));
  gh.lazySingleton<AuthBloc>(() => AuthBloc(get<Auth>()));
  gh.factory<BluetoothAuthBloc>(() =>
      BluetoothAuthBloc(get<DeviceRepository>(), get<LocalDatabaseManager>()));
  gh.lazySingleton<DeviceBloc>(() => DeviceBloc(get<DeviceRepository>()));
  gh.factory<DevicesBloc>(
      () => DevicesBloc(get<DeviceRepository>(), get<LocalDatabaseManager>()));
  gh.lazySingleton<NavigationBloc>(
      () => NavigationBloc(get<NavigationService>()));
  gh.factory<ParameterFetchBloc>(() => ParameterFetchBloc(
        get<DeviceRepository>(),
        get<ParameterHolder>(),
        get<LocalDatabaseManager>(),
      ));
  gh.lazySingleton<SettingsBloc>(() => SettingsBloc(get<SharedPrefsService>()));
  gh.factory<EntryEndpointBloc>(
      () => EntryEndpointBloc(get<DevicesBloc>(), get<SettingsBloc>()));

  // Eager singletons must be registered in the right order
  gh.singletonAsync<LocalDatabase>(() => LocalDatabase.getInstance());
  gh.singletonAsync<SharedPrefsService>(() => SharedPrefsService.getInstance());
  return get;
}

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
import '../blocs/DeviceStatisticsBloc.dart';
import '../blocs/devicesBloc.dart';
import '../blocs/entryEndpointBloc.dart';
import '../blocs/fullStatusBloc.dart';
import '../blocs/InnerPageManager.dart';
import '../persistence/localDatabase.dart';
import '../persistence/LocalDatabaseManager.dart';
import '../blocs/locationBloc.dart';
import '../blocs/LocationTracker.dart';
import '../blocs/navigationBloc.dart';
import '../blocs/navigationService.dart';
import '../blocs/OutputControlBloc.dart';
import '../blocs/PageManager.dart';
import '../blocs/parameterFetchBloc.dart';
import '../blocs/mixins/parameterAware/ParameterHolder.dart';
import '../blocs/parameterListenerBloc.dart';
import '../persistence/SembastDatabase.dart';
import '../blocs/settingsBloc.dart';
import '../blocs/sharedPrefsService.dart';
import '../blocs/shortStatusBloc.dart';
import '../blocs/stateTracker.dart';

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
  gh.factory<DeviceStatisticsBloc>(() => DeviceStatisticsBloc());
  gh.factory<FullStatusBloc>(() => FullStatusBloc(get<DeviceRepository>()));
  gh.lazySingleton<InnerPageManager>(() => InnerPageManager());
  gh.lazySingleton<LocalDatabaseManager>(
      () => LocalDatabaseManager(get<LocalDatabase>()));
  gh.lazySingleton<LocationTracker>(() => LocationTracker());
  gh.lazySingleton<NavigationService>(() => NavigationService());
  gh.lazySingleton<PageManager>(() => PageManager());
  gh.factory<ParameterFetchBloc>(
      () => ParameterFetchBloc(get<DeviceRepository>()));
  gh.lazySingleton<ParameterHolder>(() => ParameterHolder());
  gh.factory<ParameterListenerBloc>(
      () => ParameterListenerBloc(get<DeviceRepository>()));
  gh.factory<ShortStatusBloc>(() => ShortStatusBloc(get<DeviceRepository>()));
  gh.lazySingleton<Auth>(() => Auth(get<LocalDatabaseManager>()));
  gh.lazySingleton<AuthBloc>(() => AuthBloc(get<Auth>()));
  gh.factory<BluetoothAuthBloc>(() =>
      BluetoothAuthBloc(get<DeviceRepository>(), get<LocalDatabaseManager>()));
  gh.lazySingleton<DeviceBloc>(() => DeviceBloc(get<DeviceRepository>()));
  gh.factory<DevicesBloc>(
      () => DevicesBloc(get<DeviceRepository>(), get<LocalDatabaseManager>()));
  gh.factory<LocationBloc>(() => LocationBloc(get<LocationTracker>()));
  gh.lazySingleton<NavigationBloc>(
      () => NavigationBloc(get<NavigationService>()));
  gh.lazySingleton<SettingsBloc>(() => SettingsBloc(get<SharedPrefsService>()));
  gh.factory<EntryEndpointBloc>(
      () => EntryEndpointBloc(get<DevicesBloc>(), get<SettingsBloc>()));

  // Eager singletons must be registered in the right order
  gh.singletonAsync<LocalDatabase>(() => LocalDatabase.getInstance());
  gh.singleton<OutputControlBloc>(OutputControlBloc(get<DeviceRepository>()));
  gh.singletonAsync<SembastDatabase>(() => SembastDatabase.getInstance());
  gh.singletonAsync<SharedPrefsService>(() => SharedPrefsService.getInstance());
  gh.singleton<StateTracker>(StateTracker());
  return get;
}

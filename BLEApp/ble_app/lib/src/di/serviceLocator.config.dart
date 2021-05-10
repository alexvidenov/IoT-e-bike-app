// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../blocs/authBloc.dart' as _i20;
import '../blocs/btAuthenticationBloc.dart' as _i21;
import '../blocs/deviceBloc.dart' as _i22;
import '../blocs/devicesBloc.dart' as _i23;
import '../blocs/DeviceStatisticsBloc.dart' as _i5;
import '../blocs/entryEndpointBloc.dart' as _i29;
import '../blocs/fullStatusBloc.dart' as _i24;
import '../blocs/locationBloc.dart' as _i25;
import '../blocs/LocationTracker.dart' as _i8;
import '../blocs/mixins/parameterAware/ParameterHolder.dart' as _i15;
import '../blocs/MotoHoursTracker.dart' as _i9;
import '../blocs/NavDrawerBloc.dart' as _i10;
import '../blocs/navigationBloc.dart' as _i26;
import '../blocs/navigationService.dart' as _i11;
import '../blocs/OutputControlBloc.dart' as _i12;
import '../blocs/PageManager.dart' as _i13;
import '../blocs/parameterFetchBloc.dart' as _i14;
import '../blocs/parameterListenerBloc.dart' as _i16;
import '../blocs/ServiceChatBloc.dart' as _i17;
import '../blocs/settingsBloc.dart' as _i27;
import '../blocs/sharedPrefsService.dart' as _i28;
import '../blocs/shortStatusBloc.dart' as _i18;
import '../blocs/stateTracker.dart' as _i31;
import '../persistence/localDatabase.dart' as _i7;
import '../persistence/LocalDatabaseManager.dart' as _i6;
import '../persistence/SembastDatabase.dart' as _i30;
import '../repositories/DeviceRepository.dart' as _i4;
import '../services/Auth.dart' as _i19;
import '../services/CloudMessaging.dart'
    as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.CloudMessaging>(() => _i3.CloudMessaging());
  gh.lazySingleton<_i4.DeviceRepository>(() => _i4.DeviceRepository());
  gh.factory<_i5.DeviceStatisticsBloc>(() => _i5.DeviceStatisticsBloc());
  gh.lazySingleton<_i6.LocalDatabaseManager>(
      () => _i6.LocalDatabaseManager(get<_i7.LocalDatabase>()));
  gh.lazySingleton<_i8.LocationTracker>(() => _i8.LocationTracker());
  gh.factory<_i9.MotoHoursTracker>(
      () => _i9.MotoHoursTracker(get<_i4.DeviceRepository>()));
  gh.factory<_i10.NavDrawerBloc>(
      () => _i10.NavDrawerBloc(get<_i6.LocalDatabaseManager>()));
  gh.lazySingleton<_i11.NavigationService>(() => _i11.NavigationService());
  gh.lazySingleton<_i12.OutputControlBloc>(() => _i12.OutputControlBloc(
      get<_i4.DeviceRepository>(), get<_i6.LocalDatabaseManager>()));
  gh.lazySingleton<_i13.PageManager>(() => _i13.PageManager());
  gh.factory<_i14.ParameterFetchBloc>(
      () => _i14.ParameterFetchBloc(get<_i4.DeviceRepository>()));
  gh.lazySingleton<_i15.ParameterHolder>(() => _i15.ParameterHolder());
  gh.factory<_i16.ParameterListenerBloc>(
      () => _i16.ParameterListenerBloc(get<_i4.DeviceRepository>()));
  gh.factory<_i17.ServiceChatBloc>(() => _i17.ServiceChatBloc());
  gh.factory<_i18.ShortStatusBloc>(
      () => _i18.ShortStatusBloc(get<_i4.DeviceRepository>()));
  gh.lazySingleton<_i19.Auth>(() => _i19.Auth(get<_i6.LocalDatabaseManager>()));
  gh.lazySingleton<_i20.AuthBloc>(() => _i20.AuthBloc(get<_i19.Auth>()));
  gh.factory<_i21.BluetoothAuthBloc>(() => _i21.BluetoothAuthBloc(
      get<_i4.DeviceRepository>(), get<_i6.LocalDatabaseManager>()));
  gh.lazySingleton<_i22.DeviceBloc>(
      () => _i22.DeviceBloc(get<_i4.DeviceRepository>()));
  gh.factory<_i23.DevicesBloc>(() => _i23.DevicesBloc(
      get<_i4.DeviceRepository>(), get<_i6.LocalDatabaseManager>()));
  gh.factory<_i24.FullStatusBloc>(() => _i24.FullStatusBloc(
      get<_i4.DeviceRepository>(), get<_i9.MotoHoursTracker>()));
  gh.factory<_i25.LocationBloc>(
      () => _i25.LocationBloc(get<_i8.LocationTracker>()));
  gh.lazySingleton<_i26.NavigationBloc>(
      () => _i26.NavigationBloc(get<_i11.NavigationService>()));
  gh.lazySingleton<_i27.SettingsBloc>(
      () => _i27.SettingsBloc(get<_i28.SharedPrefsService>()));
  gh.factory<_i29.EntryEndpointBloc>(() => _i29.EntryEndpointBloc(
      get<_i23.DevicesBloc>(), get<_i27.SettingsBloc>()));
  gh.singletonAsync<_i7.LocalDatabase>(() => _i7.LocalDatabase.getInstance());
  gh.singletonAsync<_i30.SembastDatabase>(
      () => _i30.SembastDatabase.getInstance());
  gh.singletonAsync<_i28.SharedPrefsService>(
      () => _i28.SharedPrefsService.getInstance());
  gh.singleton<_i31.StateTracker>(_i31.StateTracker());
  return get;
}

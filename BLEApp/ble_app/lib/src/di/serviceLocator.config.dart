// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../blocs/authBloc.dart' as _i19;
import '../blocs/btAuthenticationBloc.dart' as _i20;
import '../blocs/deviceBloc.dart' as _i21;
import '../blocs/devicesBloc.dart' as _i22;
import '../blocs/DeviceStatisticsBloc.dart' as _i5;
import '../blocs/entryEndpointBloc.dart' as _i28;
import '../blocs/fullStatusBloc.dart' as _i23;
import '../blocs/locationBloc.dart' as _i24;
import '../blocs/LocationTracker.dart' as _i8;
import '../blocs/mixins/parameterAware/ParameterHolder.dart' as _i14;
import '../blocs/MotoHoursTracker.dart' as _i9;
import '../blocs/navigationBloc.dart' as _i25;
import '../blocs/navigationService.dart' as _i10;
import '../blocs/OutputControlBloc.dart' as _i11;
import '../blocs/PageManager.dart' as _i12;
import '../blocs/parameterFetchBloc.dart' as _i13;
import '../blocs/parameterListenerBloc.dart' as _i15;
import '../blocs/ServiceChatBloc.dart' as _i16;
import '../blocs/settingsBloc.dart' as _i26;
import '../blocs/sharedPrefsService.dart' as _i27;
import '../blocs/shortStatusBloc.dart' as _i17;
import '../blocs/stateTracker.dart' as _i30;
import '../persistence/localDatabase.dart' as _i7;
import '../persistence/LocalDatabaseManager.dart' as _i6;
import '../persistence/SembastDatabase.dart' as _i29;
import '../repositories/DeviceRepository.dart' as _i4;
import '../services/Auth.dart' as _i18;
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
  gh.lazySingleton<_i10.NavigationService>(() => _i10.NavigationService());
  gh.lazySingleton<_i11.OutputControlBloc>(() => _i11.OutputControlBloc(
      get<_i4.DeviceRepository>(), get<_i6.LocalDatabaseManager>()));
  gh.lazySingleton<_i12.PageManager>(() => _i12.PageManager());
  gh.factory<_i13.ParameterFetchBloc>(
      () => _i13.ParameterFetchBloc(get<_i4.DeviceRepository>()));
  gh.lazySingleton<_i14.ParameterHolder>(() => _i14.ParameterHolder());
  gh.factory<_i15.ParameterListenerBloc>(
      () => _i15.ParameterListenerBloc(get<_i4.DeviceRepository>()));
  gh.factory<_i16.ServiceChatBloc>(() => _i16.ServiceChatBloc());
  gh.factory<_i17.ShortStatusBloc>(
      () => _i17.ShortStatusBloc(get<_i4.DeviceRepository>()));
  gh.lazySingleton<_i18.Auth>(() => _i18.Auth(get<_i6.LocalDatabaseManager>()));
  gh.lazySingleton<_i19.AuthBloc>(() => _i19.AuthBloc(get<_i18.Auth>()));
  gh.factory<_i20.BluetoothAuthBloc>(() => _i20.BluetoothAuthBloc(
      get<_i4.DeviceRepository>(), get<_i6.LocalDatabaseManager>()));
  gh.lazySingleton<_i21.DeviceBloc>(
      () => _i21.DeviceBloc(get<_i4.DeviceRepository>()));
  gh.factory<_i22.DevicesBloc>(() => _i22.DevicesBloc(
      get<_i4.DeviceRepository>(), get<_i6.LocalDatabaseManager>()));
  gh.factory<_i23.FullStatusBloc>(() => _i23.FullStatusBloc(
      get<_i4.DeviceRepository>(), get<_i9.MotoHoursTracker>()));
  gh.factory<_i24.LocationBloc>(
      () => _i24.LocationBloc(get<_i8.LocationTracker>()));
  gh.lazySingleton<_i25.NavigationBloc>(
      () => _i25.NavigationBloc(get<_i10.NavigationService>()));
  gh.lazySingleton<_i26.SettingsBloc>(
      () => _i26.SettingsBloc(get<_i27.SharedPrefsService>()));
  gh.factory<_i28.EntryEndpointBloc>(() => _i28.EntryEndpointBloc(
      get<_i22.DevicesBloc>(), get<_i26.SettingsBloc>()));
  gh.singletonAsync<_i7.LocalDatabase>(() => _i7.LocalDatabase.getInstance());
  gh.singletonAsync<_i29.SembastDatabase>(
      () => _i29.SembastDatabase.getInstance());
  gh.singletonAsync<_i27.SharedPrefsService>(
      () => _i27.SharedPrefsService.getInstance());
  gh.singleton<_i30.StateTracker>(_i30.StateTracker());
  return get;
}

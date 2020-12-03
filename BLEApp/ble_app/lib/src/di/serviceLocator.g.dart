// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serviceLocator.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$Injector extends Injector {
  void _configureServices() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton((c) => DeviceRepository());
    container.registerSingleton((c) => BleManager());
    container.registerSingleton((c) => NavigationService());
    container.registerSingleton((c) => Auth());
  }

  void _configureBlocFactories() {
    final KiwiContainer container = KiwiContainer();
    container.registerFactory((c) => ShortStatusBloc(c<DeviceRepository>()));
    container.registerFactory((c) => FullStatusBloc(c<DeviceRepository>()));
    container.registerFactory((c) => BluetoothAuthBloc(c<DeviceRepository>()));
    container.registerFactory((c) => LocationBloc());
    container.registerFactory(
        (c) => DevicesBloc(c<BleManager>(), c<DeviceRepository>()));
  }

  void _configureBlocSingletons() {
    final KiwiContainer container = KiwiContainer();
    container.registerSingleton((c) => EntryEndpointBloc());
    container.registerSingleton((c) => SettingsBloc(c<SharedPrefsService>()));
    container.registerSingleton(
        (c) => DeviceBloc(c<BleManager>(), c<DeviceRepository>()));
    container.registerSingleton((c) => NavigationBloc(c<NavigationService>()));
  }
}

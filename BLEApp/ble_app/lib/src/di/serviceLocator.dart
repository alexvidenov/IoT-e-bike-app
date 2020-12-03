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
import 'package:kiwi/kiwi.dart';

part 'serviceLocator.g.dart';

abstract class Injector {
  static KiwiContainer container;

  static Future<void> setup() async {
    container = KiwiContainer();
    await SharedPrefsService.getInstance()
        .then((prefs) => container.registerInstance(prefs));
    _$Injector()._configure();
  }

  static final $ = container.resolve;

  void _configure(){
    _configureBlocFactories();
    _configureBlocSingletons();
    _configureServices();
  }

  @Register.singleton(DeviceRepository)
  @Register.singleton(BleManager)
  @Register.singleton(NavigationService)
  @Register.singleton(Auth)
  void _configureServices();

  @Register.factory(ShortStatusBloc)
  @Register.factory(FullStatusBloc)
  @Register.factory(BluetoothAuthBloc)
  @Register.factory(LocationBloc)
  @Register.factory(DevicesBloc)
  void _configureBlocFactories();

  @Register.singleton(EntryEndpointBloc)
  @Register.singleton(SettingsBloc)
  @Register.singleton(DeviceBloc)
  @Register.singleton(NavigationBloc)
  void _configureBlocSingletons();

}

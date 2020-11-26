import 'dart:async';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

enum Endpoint { Unknown, DevicesScreen, AuthScreen }

class EntryEndpointBloc extends Bloc<Endpoint, Endpoint> {
  final devicesBloc = locator<DevicesBloc>();

  StreamSubscription _devicePickedSubscription;

  _listen() {
    _devicePickedSubscription = devicesBloc.pickedDevice.listen((_) {
      this.pause();
      devicesBloc.pause();
      addEvent(Endpoint.AuthScreen);
    });
  }

  void _determineEndpoint(){
    String _deviceId = locator<SettingsBloc>().getOptionalDeviceId();
    if (_deviceId != 'empty') {
      BleDevice device = BleDevice(peripheral: BleManager().createUnsafePeripheral(_deviceId));
      _listen();
      devicesBloc.init();
      devicesBloc.create();
      devicesBloc.addEvent(device);
    } else {
      addEvent(Endpoint.DevicesScreen);
    }
  }

  @override
  void create() => _determineEndpoint();

  @override
  void pause() => _devicePickedSubscription.cancel();

  @override
  void resume() {}
}

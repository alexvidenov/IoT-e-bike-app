import 'dart:async';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';

enum Endpoint { Unknown, DevicesScreen, AuthScreen }

@lazySingleton
class EntryEndpointBloc extends Bloc<Endpoint, Endpoint> {
  final DevicesBloc _devicesBloc;
  final SettingsBloc _settingsBloc;

  StreamSubscription _devicePickedSubscription;

  EntryEndpointBloc(this._devicesBloc, this._settingsBloc);

  _listen() => _devicePickedSubscription = _devicesBloc.pickedDevice.listen((_) {
      this.pause();
      _devicesBloc.pause();
      addEvent(Endpoint.AuthScreen);
    });

  void _determineEndpoint() {
    String _deviceId = _settingsBloc.getOptionalDeviceId();
    if (_deviceId != 'empty') {
      BleDevice device =
          BleDevice(peripheral: BleManager().createUnsafePeripheral(_deviceId));
      _listen();
      _devicesBloc.init();
      _devicesBloc.create();
      _devicesBloc.addEvent(device);
    } else {
      addEvent(Endpoint.DevicesScreen);
    }
  }

  @override
  void create() => _determineEndpoint();

  @override
  void pause() => _devicePickedSubscription.cancel();
}

import 'dart:async';

import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/prefs/settingsBloc.dart';
import 'package:ble_app/src/modules/BleDevice.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';

import 'base/bloc.dart';

part 'blocExtensions/DetermineEndpoint.dart';

enum Endpoint { Unknown, DevicesScreen, AuthScreen }

@injectable
class EntryEndpointBloc extends Bloc<Endpoint, Endpoint> {
  final DevicesBloc _devicesBloc;
  final SettingsBloc _settingsBloc;

  StreamSubscription _devicePickedSubscription;

  EntryEndpointBloc(this._devicesBloc, this._settingsBloc);

  _listenForPickedDevice() =>
      _devicePickedSubscription = _devicesBloc.pickedDevice.listen((_) {
        this.pause();
        _devicesBloc.pause();
        addEvent(Endpoint.AuthScreen);
      });

  @override
  create() => _determineEndpoint();

  @override
  pause() => _devicePickedSubscription?.cancel();
}

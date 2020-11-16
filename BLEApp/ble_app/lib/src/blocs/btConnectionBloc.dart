import 'dart:async';

import 'package:ble_app/src/BluetoothUtils.dart';
import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:ble_app/src/blocs/StreamOwner.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ConnectionBloc extends StreamOwner {
  final _bluetoothState$ = BehaviorSubject<
      ConnectionEvent>(); // this is essentially a StreamController, keeping the last emitted value

  Stream<ConnectionEvent> get bluetoothState =>
      _bluetoothState$.stream; // UI listens here

  ConnectionBloc() {
    GetIt.I<BluetoothRepository>().connectionStream.listen((event) {
      // rename the repo status to something else to make more sense. Here, just switch the repo status and emit ConnectionEvent.
      _bluetoothState$.sink.add(event);
    });
  }

  connect() {
    GetIt.I<BluetoothRepository>().connectToDevice();
  }

  disconnect() {
    GetIt.I<BluetoothRepository>().disconnectFromDevice();
  }

  @override
  void dispose() {
    _bluetoothState$.close();
    GetIt.I<BluetoothRepository>().dispose();
  }
}

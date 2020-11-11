import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ble_app/src/BluetoothUtils.dart';
import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:ble_app/src/blocs/Bloc.dart';
import 'package:rxdart/rxdart.dart';

class ConnectionBloc extends Bloc {
  final BluetoothRepository repository;

  final _bluetoothState$ = BehaviorSubject<
      ConnectionEvent>(); // this is essentially a StreamController

  Stream<ConnectionEvent> get bluetoothState =>
      _bluetoothState$.stream; // UI listens here

  ConnectionBloc({@required this.repository}) {
    repository.connectionStream.listen((event) {
      // rename the repo status to something else to make more sense. Here, just switch the repo status and emit ConnectionEvent.
      _bluetoothState$.sink.add(event);
    });
  }

  connect() {
    this.repository.connectToDevice();
  }

  disconnect() {
    this.repository.disconnectFromDevice();
  }

  @override
  void dispose() {
    _bluetoothState$.close();
  }
}

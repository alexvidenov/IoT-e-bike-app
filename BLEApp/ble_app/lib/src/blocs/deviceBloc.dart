import 'dart:async';
import 'package:ble_app/src/listeners/disconnectedListener.dart';
import 'package:ble_app/src/main.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part '../extensions/DeviceConnectionMethods.dart';

@lazySingleton
class DeviceBloc {
  final BleManager _bleManager;
  final DeviceRepository _deviceRepository;

  BehaviorSubject<bool> _isDeviceReadyController;

  DisconnectedListener _disconnectedListener;

  Stream<bool> get deviceReady => _isDeviceReadyController.stream;

  Sink<bool> get _setDeviceReady => _isDeviceReadyController.sink;

  BehaviorSubject<BleDevice> _deviceController;

  ValueStream<BleDevice> get device => _deviceController.stream;

  BehaviorSubject<PeripheralConnectionState> _connectionStateController;

  Stream<PeripheralConnectionState> get connectionState =>
      _connectionStateController.stream;

  Sink<PeripheralConnectionState> get _connectionEvent =>
      _connectionStateController.sink;

  Stream<BleDevice> get disconnectedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice != null);

  DeviceBloc(this._deviceRepository) : this._bleManager = BleManager() {
    final device = _deviceRepository.pickedDevice.value;
    _deviceController = BehaviorSubject<BleDevice>.seeded(device);

    _connectionStateController = BehaviorSubject<PeripheralConnectionState>();
    _isDeviceReadyController = BehaviorSubject<bool>.seeded(false);
  }

  setDisconnectedListener(DisconnectedListener listener) =>
      _disconnectedListener = listener;

  removeListener() => _disconnectedListener = null;

  init() => _bleManager.stopPeripheralScan();

  _observeConnectionState() => device.listen((bleDevice) => bleDevice.peripheral
          .observeConnectionState(
              emitCurrentValue: true, completeOnDisconnect: true)
          .listen((connectionState) {
        _connectionEvent.add(connectionState);
        if (connectionState == PeripheralConnectionState.connected) {
          _disconnectedListener?.onReconnected();
        } else if (connectionState == PeripheralConnectionState.disconnected) {
          _disconnectedListener?.onDisconnected();
        }
      }));

  dispose() async {
    logger.wtf('Closing stream in DeviceBloc');
    await _deviceController.drain();
    _deviceController.close();

    await _connectionStateController.drain();
    _connectionStateController.close();

    _isDeviceReadyController.close();
  }
}

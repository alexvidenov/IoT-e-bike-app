import 'dart:async';
import 'package:ble_app/src/listeners/DisconnectedListener.dart';
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

  DisconnectedListener _disconnectedListener;

  BehaviorSubject<bool> _isDeviceReadyController;

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

  init() => _bleManager.stopPeripheralScan();

  _observeConnectionState() => device.listen((bleDevice) => bleDevice.peripheral
          .observeConnectionState(
              emitCurrentValue: true, completeOnDisconnect: false)
          .listen((connectionState) {
        if (connectionState == PeripheralConnectionState.connected)
          _disconnectedListener?.onReconnected();
        else if (connectionState == PeripheralConnectionState.disconnected)
          _disconnectedListener?.onDisconnected();
        _connectionEvent.add(connectionState);
      }));

  dispose() async {
    await _deviceController.drain();
    _deviceController.close();

    await _connectionStateController.drain();
    _connectionStateController.close();

    _isDeviceReadyController.close();
  }
}

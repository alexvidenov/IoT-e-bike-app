import 'dart:async';
import 'package:ble_app/src/data/BleDevice.dart';
import 'package:ble_app/src/data/DeviceRepository.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:rxdart/rxdart.dart';

class DeviceBloc {
  final BleManager _bleManager;
  final DeviceRepository _deviceRepository;

  BehaviorSubject<BleDevice> _deviceController;

  ValueStream<BleDevice> get device => _deviceController.stream;

  BehaviorSubject<PeripheralConnectionState> _connectionStateController;

  Stream<PeripheralConnectionState> get connectionState =>
      _connectionStateController.stream;

  Sink<PeripheralConnectionState> get _connectionEvent =>
      _connectionStateController.sink;

  Stream<BleDevice> get disconnectedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice != null);

  DeviceBloc(this._deviceRepository, this._bleManager) {
    var device = _deviceRepository.pickedDevice.value;
    _deviceController = BehaviorSubject<BleDevice>.seeded(device);

    _connectionStateController = BehaviorSubject<PeripheralConnectionState>();
  }

  void init() {
    _bleManager.stopPeripheralScan();
  }

  Future<void> disconnect() async {
    _disconnectManual();
    return _deviceRepository.pickDevice(null);
  }

  Future<void> _disconnectManual() async {
    if (await device.value.peripheral.isConnected()) {
      await _deviceController.stream.value.peripheral
          .disconnectOrCancelConnection();
    }
  }

  _observeConnectionState() {
    device.listen((bleDevice) {
      var peripheral = bleDevice.peripheral;
      peripheral
          .observeConnectionState(
              emitCurrentValue: true, completeOnDisconnect: true)
          .listen((connectionState) {
        _connectionEvent.add(connectionState);
      });
    });
  }

  Future<void> connect() async {
    device.listen((bleDevice) async {
      var peripheral = bleDevice.peripheral;
      await peripheral
          .connect()
          .then((_) => _observeConnectionState())
          .then((_) => _deviceRepository.discoverServicesAndStartMonitoring());
    });
  }

  void dispose() async {
    await _deviceController.drain();
    _deviceController.close();

    await _connectionStateController.drain();
    _connectionStateController.close();
  }
}

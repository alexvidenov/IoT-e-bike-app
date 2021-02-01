import 'dart:async';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/modules/BleDevice.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/sealedStates/deviceConnectionState.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'blocExtensions/DeviceConnectionMethods.dart';

@lazySingleton
class DeviceBloc {
  final BleManager _bleManager = BleManager();
  final DeviceRepository _deviceRepository;

  BehaviorSubject<bool> _isDeviceReadyController; // TODO: replace with RxObject

  Stream<bool> get deviceReady => _isDeviceReadyController.stream;

  Sink<bool> get _setDeviceReady => _isDeviceReadyController.sink;

  BehaviorSubject<BleDevice> _deviceController;

  ValueStream<BleDevice> get device => _deviceController.stream;

  BehaviorSubject<DeviceConnectionState> _connectionStateController;

  Stream<DeviceConnectionState> get connectionState =>
      _connectionStateController.stream;

  Sink<DeviceConnectionState> get _connectionEvent =>
      _connectionStateController.sink;

  Stream<BleDevice> get disconnectedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice != null);

  DeviceBloc(this._deviceRepository) {
    final device = _deviceRepository.pickedDevice.value;
    _deviceController = BehaviorSubject<BleDevice>.seeded(device);

    _connectionStateController = BehaviorSubject<DeviceConnectionState>();
    _isDeviceReadyController = BehaviorSubject<bool>.seeded(false);
  }

  cancel() => _deviceRepository.cancel();

  stopScan() => _bleManager.stopPeripheralScan();

  _observeConnectionState() => device.listen((bleDevice) => bleDevice.peripheral
      .observeConnectionState(
          emitCurrentValue: true, completeOnDisconnect: false)
      .listen((state) => _connectionEvent
          .add(DeviceConnectionState.normalBTState(state: state))));

  dispose() async {
    logger.wtf('Closing stream in DeviceBloc');
    await _deviceController.drain();
    _deviceController.close();

    await _connectionStateController.drain();
    _connectionStateController.close();

    _isDeviceReadyController.close();
  }
}

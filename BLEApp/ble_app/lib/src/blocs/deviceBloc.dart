import 'dart:async';
import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/listeners/disconnectedListener.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/modules/BleDevice.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/sealedStates/deviceConnectionState.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'blocExtensions/DeviceConnectionMethods.dart';

enum OutputsState { On, Off }

@lazySingleton
class DeviceBloc {
  final BleManager _bleManager = BleManager();
  final DeviceRepository _deviceRepository;

  BehaviorSubject<bool> _isDeviceReadyController; // TODO: replace with RxObject

  DisconnectedListener _disconnectedListener;

  Stream<bool> get deviceReady =>
      _isDeviceReadyController.stream.doOnData((event) {
        if (event == true) _disconnectedListener?.onReadyToAuthenticate();
      });

  Sink<bool> get _setDeviceReady => _isDeviceReadyController.sink;

  BehaviorSubject<BleDevice> _deviceController;

  ValueStream<BleDevice> get device => _deviceController.stream;

  BehaviorSubject<DeviceConnectionState> _connectionStateController;

  final _lockedRx = RxObject<OutputsState>();

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

  setDisconnectedListener(DisconnectedListener listener) =>
      _disconnectedListener = listener;

  removeListener() => _disconnectedListener = null;

  writeToBLE(String data) => _deviceRepository.writeToCharacteristic(data);

  cancel() => _deviceRepository.cancel();

  stopScan() => _bleManager.stopPeripheralScan();

  on() => _lockedRx.addEvent(OutputsState.On);

  off() => _lockedRx.addEvent(OutputsState.Off);

  _observeConnectionState() => device.listen((bleDevice) => bleDevice.peripheral
          .observeConnectionState(
              emitCurrentValue: true,
              completeOnDisconnect:
                  false) // was true and it's better off to stay false (i think?)
          .listen((state) {
        print('STATE CHANGING TO $state');
        _connectionEvent.add(DeviceConnectionState.normalBTState(state: state));
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

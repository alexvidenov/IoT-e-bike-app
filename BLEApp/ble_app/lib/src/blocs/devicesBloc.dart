import 'dart:async';
import 'dart:convert';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/utils/bluetoothUtils.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'LocalDatabaseManager.dart';

part 'blocExtensions/BLEScanMethods.dart';

@injectable
class DevicesBloc extends Bloc<BleDevice, BleDevice> {
  final DeviceRepository _deviceRepository;
  final LocalDatabaseManager _dbManager;
  final BleManager _bleManager = BleManager();

  final List<BleDevice> bleDevices = <BleDevice>[];

  BehaviorSubject<List<BleDevice>> _visibleDevicesController =
      BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);

  StreamSubscription<ScanResult> _scanSubscription;

  ValueStream<List<BleDevice>> get visibleDevices =>
      _visibleDevicesController.stream;

  Stream<BleDevice> get pickedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice == null);

  DevicesBloc(this._deviceRepository, this._dbManager);

  _handlePickedDevice(BleDevice bleDevice) =>
      _deviceRepository.pickDevice(bleDevice);

  init() {
    bleDevices.clear();
    _checkBluetooth().then((_) => _startScan());

    if (_visibleDevicesController.isClosed)
      _visibleDevicesController =
          BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);
  }

  Future<void> _checkBluetooth() async {
    if (await _bleManager.bluetoothState() != BluetoothState.POWERED_ON)
      await _bleManager.enableRadio();
  }

  @override
  create() => streamSubscription = stream.listen(_handlePickedDevice);

  @override
  pause() => _stopScan();

  @override
  resume() => init();

  @override
  dispose() {
    super.dispose();
    logger.wtf('Closing stream in DevicesBloc');
    _visibleDevicesController.close();
    _scanSubscription?.cancel();
    _stopScan();
  }
}

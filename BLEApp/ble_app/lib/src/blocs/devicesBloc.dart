import 'dart:async';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class DevicesBloc extends Bloc<BleDevice, BleDevice> {
  final DeviceRepository _deviceRepository;
  final BleManager _bleManager;

  final List<BleDevice> bleDevices = <BleDevice>[];

  BehaviorSubject<List<BleDevice>> _visibleDevicesController =
      BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);

  StreamSubscription<ScanResult> _scanSubscription;

  ValueStream<List<BleDevice>> get visibleDevices =>
      _visibleDevicesController.stream;

  Stream<BleDevice> get pickedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice == null);

  DevicesBloc(this._deviceRepository) : this._bleManager = BleManager();

  void _handlePickedDevice(BleDevice bleDevice) =>
      _deviceRepository.pickDevice(bleDevice);

  void init() {
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

  void _startScan() {
    _scanSubscription =
        _bleManager.startPeripheralScan().listen((ScanResult scanResult) {
      // add uuid-specific search later on
      var bleDevice = BleDevice(peripheral: scanResult.peripheral);
      if (scanResult.advertisementData.localName != null &&
          !bleDevices.contains(bleDevice)) {
        bleDevices.add(bleDevice);
        _visibleDevicesController.add(bleDevices.sublist(0));
      }
    });
  }

  void _stopScan() => _bleManager.stopPeripheralScan();

  Future<void> refresh() async {
    _scanSubscription?.cancel();
    await _bleManager.stopPeripheralScan();
    bleDevices.clear();
    _visibleDevicesController.add(bleDevices.sublist(0));
    _startScan();
  }

  @override
  void dispose() {
    super.dispose();
    _visibleDevicesController.close();
    _scanSubscription?.cancel();
    _stopScan();
  }

  @override
  void create() => streamSubscription = stream.listen(_handlePickedDevice);

  @override
  void pause() => _stopScan();

  @override
  void resume() => init();
}

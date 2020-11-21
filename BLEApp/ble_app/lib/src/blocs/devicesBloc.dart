import 'dart:async';

import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:rxdart/rxdart.dart';

class DevicesBloc {
  final List<BleDevice> bleDevices = <BleDevice>[];

  BehaviorSubject<List<BleDevice>> _visibleDevicesController =
      BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);

  StreamController<BleDevice> _devicePickerController =
      StreamController<BleDevice>();

  StreamSubscription<ScanResult> _scanSubscription;
  StreamSubscription _devicePickerSubscription;

  ValueStream<List<BleDevice>> get visibleDevices =>
      _visibleDevicesController.stream;

  Sink<BleDevice> get devicePicker => _devicePickerController.sink;

  DeviceRepository _deviceRepository;
  BleManager _bleManager;

  Stream<BleDevice> get pickedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice == null);

  DevicesBloc(this._deviceRepository, this._bleManager);

  void _handlePickedDevice(BleDevice bleDevice) {
    _deviceRepository.pickDevice(bleDevice);
  }

  void init() {
    bleDevices.clear();
    _checkBluetooth().then((_) => _startScan());

    if (_visibleDevicesController.isClosed) {
      _visibleDevicesController =
          BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);
    }

    if (_devicePickerController.isClosed) {
      _devicePickerController = StreamController<BleDevice>();
    }
    _devicePickerSubscription =
        _devicePickerController.stream.listen(_handlePickedDevice);
  }

  Future<void> _checkBluetooth() async {
    if (await _bleManager.bluetoothState() != BluetoothState.POWERED_ON)
      await _bleManager.enableRadio();
  }

  void _startScan() {
    _scanSubscription =
        _bleManager.startPeripheralScan().listen((ScanResult scanResult) {
      // add uuids later on
      var bleDevice = BleDevice(peripheral: scanResult.peripheral);
      if (scanResult.advertisementData.localName != null &&
          !bleDevices.contains(bleDevice)) {
        bleDevices.add(bleDevice);
        _visibleDevicesController.add(bleDevices.sublist(0));
      }
    });
  }

  void _stopScan() {
    _bleManager.stopPeripheralScan();
  }

  Future<void> refresh() async {
    _scanSubscription?.cancel();
    await _bleManager.stopPeripheralScan();
    bleDevices.clear();
    _visibleDevicesController.add(bleDevices.sublist(0));
    _startScan();
  }

  void dispose() {
    _devicePickerSubscription.cancel();
    _visibleDevicesController.close();
    _devicePickerController.close();
    _scanSubscription?.cancel();
    _stopScan();
  }
}

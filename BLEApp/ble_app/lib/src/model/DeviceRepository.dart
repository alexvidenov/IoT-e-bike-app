import 'dart:async';
import 'dart:convert';

import 'package:ble_app/src/utils/bluetoothUtils.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/utils/DataParser.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:rxdart/rxdart.dart';

class DeviceRepository {
  static BleDevice _bleDevice;
  BehaviorSubject<BleDevice> _deviceController;

  static final DeviceRepository _deviceRepository =
      DeviceRepository._internal();

  String _deviceSerialNumber; // will be updated on every call to connect()

  Characteristic _characteristic;
  StreamSubscription _characteristicSubscription;

  String _value = ""; // will be updated every packet
  String _curValue = ""; // which will be appended to

  Timer _timer;

  final _characteristicController =
      PublishSubject<String>(); // packets, emmited from bluetooth

  Stream<String> get characteristicValueStream =>
      _characteristicController.stream;

  Sink<String> get _characteristicValueSink => _characteristicController.sink;

  ValueStream<BleDevice> get pickedDevice =>
      _deviceController.stream.shareValueSeeded(_bleDevice);

  bool get hasPickedDevice => _bleDevice != null;

  factory DeviceRepository() => _deviceRepository;

  DeviceRepository._internal() {
    _deviceController = BehaviorSubject<BleDevice>.seeded(_bleDevice);
  }

  void pickDevice(BleDevice bleDevice) async {
    _bleDevice = bleDevice;
    _deviceController.add(_bleDevice);
  }

  _addCharacteristicEvent(String event) => _characteristicValueSink.add(event);

  _listenToCharacteristic() {
    _characteristicSubscription = _characteristic?.monitor()?.listen((event) {
      if (event.length != 0) {
        if (event.contains(10)) {
          for (int i = 0; i < event.length; i++) {
            if (event.elementAt(i) == 10) {
              _value = _curValue;
              _addCharacteristicEvent(_value);
              _curValue = "";
            } else {
              List<int> curList = [event.elementAt(i)];
              _curValue += DataParser.parseList(curList);
            } //the problem was that I wasn't updating curValue after passing the '\n' in the packet
          }
        } else {
          _curValue += DataParser.parseList(event);
        }
      }
    });
  }

  _writeData(String data) {
    List<int> bytes = utf8.encode(data);
    _characteristic?.write(bytes, false);
  }

  writeToCharacteristic(String data) => _writeData(data);

  periodicShortStatus() {
    _timer?.cancel();
    _timer =
        Timer.periodic(Duration(milliseconds: 500), (_) => _writeData("S"));
  }

  periodicFullStatus() {
    _timer?.cancel();
    _timer =
        Timer.periodic(Duration(milliseconds: 500), (_) => _writeData("F"));
  }

  cancel() => _timer?.cancel();

  resumeTimer(bool isShort) =>
      isShort ? periodicShortStatus() : periodicFullStatus();

  Future<void> discoverServicesAndStartMonitoring() async => await _discover()
      .then((c) => this._characteristic = c)
      .then((c) => _listenToCharacteristic());

  Future<Characteristic> _discover() async {
    await _bleDevice.peripheral.discoverAllServicesAndCharacteristics();

    Service _service = await _bleDevice.peripheral.services().then((services) =>
        services.firstWhere(
            (service) => service.uuid == BluetoothUtils.SERVICE_UUID));

    List<Characteristic> _characteristics = await _service.characteristics();

    final c = _characteristics.firstWhere((characteristic) =>
        characteristic.uuid == BluetoothUtils.CHARACTERISTIC_UUID);

    _characteristic = c;

    return c;
  }

  String get deviceId => _deviceSerialNumber;

  set deviceSerialNumber(String id) => _deviceSerialNumber = id;

  void dispose() {
    _characteristicSubscription.cancel();
    _characteristicController.close();
  }
}

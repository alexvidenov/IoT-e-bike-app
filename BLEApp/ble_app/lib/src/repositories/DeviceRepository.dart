import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/utils/bluetoothUtils.dart';
import 'package:ble_app/src/modules/BleDevice.dart';
import 'package:ble_app/src/utils/dataParser.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

enum CurrentStatus { ShortStatus, FullStatus }

@lazySingleton
class DeviceRepository {
  static BleDevice _bleDevice;

  BehaviorSubject<BleDevice> _deviceController;

  ValueStream<BleDevice> get pickedDevice =>
      _deviceController.stream.shareValueSeeded(_bleDevice);

  String _deviceSerialNumber; // will be updated on every call to connect()

  Characteristic _characteristic;
  StreamSubscription<Uint8List> _characteristicSubscription;

  CurrentStatus _currentStatus;

  String _value = ""; // will be updated every packet
  String _curValue = ""; // will be appended to

  Timer _timer; // timer for the periodic commands. TODO: extract

  final _characteristicRx = RxObject<String>();

  Stream<String> get characteristicValueStream => _characteristicRx.stream;

  bool get hasPickedDevice => _bleDevice != null;

  DeviceRepository() {
    _deviceController = BehaviorSubject<BleDevice>.seeded(_bleDevice);
  }

  pickDevice(BleDevice bleDevice) async {
    _bleDevice = bleDevice;
    _deviceController.add(_bleDevice);
  }

  //_addCharacteristicEvent(String event) => _characteristicValueSink.add(event);

  _listenToCharacteristic() {
    _characteristicSubscription = _characteristic?.monitor()?.listen((event) {
      print('DATA EVENT: ' + event.toString());
      if (event.length != 0) {
        if (event.contains(10)) {
          for (int i = 0; i < event.length; i++) {
            if (event.elementAt(i) == 10) {
              _value = _curValue;
              _characteristicRx.addEvent(_value);
              // _addCharacteristicEvent(_value);
              _curValue = "";
            } else {
              _curValue += DataParser.parseList([event.elementAt(i)]);
            }
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

  Future<String> readCharacteristic() async =>
      await _characteristic.read().then((value) => utf8.decode(value));

  periodicShortStatus() {
    _timer?.cancel();
    _timer =
        Timer.periodic(Duration(milliseconds: 300), (_) => _writeData('N\r'));
    _currentStatus = CurrentStatus.ShortStatus;
  }

  periodicFullStatus() {
    _timer?.cancel();
    _timer =
        Timer.periodic(Duration(milliseconds: 400), (_) => _writeData('F\r'));
    _currentStatus = CurrentStatus.FullStatus;
  }

  cancel() => _timer?.cancel();

  resumeTimer(bool isShort) =>
      isShort ? periodicShortStatus() : periodicFullStatus();

  resume() {
    switch (_currentStatus) {
      case CurrentStatus.ShortStatus:
        periodicShortStatus();
        break;
      case CurrentStatus.FullStatus:
        periodicFullStatus();
        break;
    }
  }

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

    _characteristic = c; // FIXME THIS IS DUPLICATION

    return c;
  }

  String get deviceId => _deviceSerialNumber;

  set deviceSerialNumber(String id) =>
      _deviceSerialNumber = id; // TODO: fix the shitty naming here here

  dispose() {
    _characteristicSubscription?.cancel();
    _characteristicRx.dispose();
    //_characteristicController.close();
  }
}

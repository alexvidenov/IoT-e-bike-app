import 'dart:async';
import 'dart:convert';

import 'package:ble_app/src/bluetoothUtils.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';
/*
abstract class AbstractBluetoothRepositoryFactory<T> extends StreamOwner<T> {
  // prolly constrain it to only handle models T extends Model
  final behaviorSubject = BehaviorSubject<T>();

  Stream<T> get stream => behaviorSubject.stream;

  Sink<T> get sink => behaviorSubject.sink;

  @override
  void dispose() {
    behaviorSubject.close();
  }

  @override
  void addEvent(T event) {
    sink.add(event);
  }

  void connect();
}
*/

class BluetoothRepository {
  static BluetoothDevice
      bluetooth; // static device for the whole application session

  String _value = ""; // will be updated every packet
  String _curValue = ""; // which will be appended to
  BluetoothCharacteristic _characteristic;
  Timer _characteristicTimer;

  static final BluetoothRepository _instance = BluetoothRepository._internal();

  final _bluetoothController = BehaviorSubject<BluetoothDeviceState>();

  final _characteristicController =
      BehaviorSubject<String>(); // packets, emmited from bluetooth

  Stream<BluetoothDeviceState> get connectionStream =>
      _bluetoothController.stream;

  Sink<BluetoothDeviceState> get _connectionSink => _bluetoothController.sink;

  Stream<String> get characteristicValueStream =>
      _characteristicController.stream;

  Sink<String> get _characteristicValueSink => _characteristicController.sink;

  factory BluetoothRepository(BluetoothDevice device) {
    // factory construvtor makes sure we have only one instance of a class
    bluetooth = device;
    return _instance;
  }

  BluetoothRepository._internal() {
    _listenToBluetoothState();
  }

  _listenToBluetoothState() {
    bluetooth.state.listen((event) {
      _addConnectionEvent(event);
    });
  }

  _addConnectionEvent(BluetoothDeviceState event) {
    _connectionSink.add(event);
  }

  _addCharacteristicEvent(String event) {
    _characteristicValueSink.add(event);
  }

  Future<void> connectToDevice() async {
    await bluetooth.connect();
    await _discoverServices();
  }

  Future<dynamic> disconnectFromDevice() async {
    await bluetooth.disconnect();
  }

  Future<void> _discoverServices() async {
    List<BluetoothService> services = await bluetooth.discoverServices();
    await bluetooth.requestMtu(512);
    for (BluetoothService service in services) {
      if (service.uuid.toString() == BluetoothUtils.SERVICE_UUID) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() ==
              BluetoothUtils.CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(true);
            this._characteristic = characteristic;
            listenToCharacteristic(); // dont call these immediately here
            periodicWriteToCharacteristic();
          }
        }
      }
    }
  }

  listenToCharacteristic() {
    // prolly add a stream subscription to handle cancel case
    _characteristic.value.listen((event) {
      // event is List<int>
      if (event.length != 0) {
        if (event.contains(10)) {
          for (int i = 0; i < event.length; i++) {
            if (event.elementAt(i) == 10) {
              _value = _curValue;
              _addCharacteristicEvent(_value);
              _curValue = "";
            } else {
              List<int> curList = [event.elementAt(i)];
              _curValue += _dataParser(curList);
            } //the problem was that I wasn't updating curValue after passing the '\n' in the packet
          }
        } else {
          _curValue += _dataParser(event);
        }
      }
    });
  }

  cancelTimer() {
    _characteristicTimer.cancel();
  }

  periodicWriteToCharacteristic() {
    _characteristicTimer =
        Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      writeData("S");
    });
  }

  resumeTimer() {
    periodicWriteToCharacteristic();
  }

  writeData(String data) {
    if (_characteristic == null) return;

    List<int> bytes = utf8.encode(data);
    _characteristic.write(bytes);
  }

  String _dataParser(List<int> dataFromDevice) {
    // prolly move it to Utils class
    return utf8.decode(dataFromDevice);
  }

  void dispose() {
    _bluetoothController.close();
    _characteristicController.close();
  }
}

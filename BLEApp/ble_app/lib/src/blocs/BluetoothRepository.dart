import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:ble_app/src/BluetoothUtils.dart';
import 'package:rxdart/rxdart.dart';

abstract class StreamOwner {
  void dispose();
}

class BluetoothRepository extends StreamOwner {
  static BluetoothDevice
      bluetooth; // static device for the whole application session

  bool _isReady = false;
  String _value = ""; // will be updated every packet
  String _curValue = ""; // which will be appended to
  BluetoothCharacteristic _characteristic;

  static final BluetoothRepository _instance = BluetoothRepository._internal();

  final _bluetoothController = BehaviorSubject<ConnectionEvent>();

  final _characteristicController =
      BehaviorSubject<String>(); // packets, emmited from bluetooth

  Stream<ConnectionEvent> get connectionStream => _bluetoothController.stream;

  Sink<ConnectionEvent> get _connectionSink => _bluetoothController.sink;

  Stream<String> get characteristicValueStream =>
      _characteristicController.stream;

  Sink<String> get _characteristicValueSink => _characteristicController.sink;

  factory BluetoothRepository(BluetoothDevice device) {
    // factory construvtor makes sure we have only one instance of a class
    bluetooth = device;
    return _instance;
  }

  BluetoothRepository._internal();

  _addConnectionEvent(ConnectionEvent event) {
    _connectionSink.add(event);
  }

  _addCharacteristicEvent(String event) {
    _characteristicValueSink.add(event);
  }

  connectToDevice() async {
    if (bluetooth == null) {
      _addConnectionEvent(ConnectionEvent.FailedToConnect);
      return;
    }

    _addConnectionEvent(ConnectionEvent.Connecting);

    new Timer(const Duration(seconds: 15), () {
      if (!_isReady) {
        disconnectFromDevice();
        _addConnectionEvent(ConnectionEvent.FailedToConnect);
      }
    });

    await bluetooth.connect();
    _discoverServices();
  }

  disconnectFromDevice() {
    if (bluetooth == null) {
      _addConnectionEvent(ConnectionEvent.FailedToConnect);
      return;
    }

    bluetooth.disconnect();
  }

  _discoverServices() async {
    if (bluetooth == null) {
      _addConnectionEvent(ConnectionEvent.FailedToConnect);
    }

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
            _addConnectionEvent(ConnectionEvent.Connected);
            _isReady = true;
            listenToCharacteristic();
            periodicWriteToCharacteristic();
          }
        }
      }
    }

    if (!_isReady) {
      _addConnectionEvent(ConnectionEvent.FailedToConnect);
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

  periodicWriteToCharacteristic() {
    new Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      writeData("S");
    });
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

  @override
  void dispose() {
    _bluetoothController.close();
    _characteristicController.close();
  }
}

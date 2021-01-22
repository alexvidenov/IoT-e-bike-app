import 'dart:async';
import 'dart:convert';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/jsonClasses/bleCacheModel.dart';
import 'package:ble_app/src/utils/bluetoothUtils.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'blocExtensions/BLEScanMethods.dart';

@injectable
class DevicesBloc extends Bloc<BleDevice, BleDevice> {
  final DeviceRepository _deviceRepository;
  final SettingsBloc _settingsBloc;
  final BleManager _bleManager;

  final List<BleDevice> bleDevices = <BleDevice>[];

  BehaviorSubject<List<BleDevice>> _visibleDevicesController =
      BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);

  StreamSubscription<ScanResult> _scanSubscription;

  ValueStream<List<BleDevice>> get visibleDevices =>
      _visibleDevicesController.stream;

  Stream<BleDevice> get pickedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice == null);

  DevicesBloc(this._deviceRepository, this._settingsBloc)
      : this._bleManager = BleManager();

  _handlePickedDevice(BleDevice bleDevice) => _deviceRepository.pickDevice(bleDevice);

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
  dispose() {
    super.dispose();
    logger.wtf('Closing stream in DevicesBloc');
    _visibleDevicesController.close();
    _scanSubscription?.cancel();
    _stopScan();
  }

  @override
  create() => streamSubscription = stream.listen(_handlePickedDevice);

  @override
  pause() => _stopScan();

  @override
  resume() => init();
}

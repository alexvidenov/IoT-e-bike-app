import 'dart:async';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/BleDevice.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/utils/bluetoothUtils.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart' as locationPerm;
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:injectable/injectable.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:rxdart/rxdart.dart';

import '../persistence/LocalDatabaseManager.dart';
import 'PageManager.dart';

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

  StreamSubscription<BleDevice> _pickedDevicesSubscription;

  ValueStream<List<BleDevice>> get visibleDevices =>
      _visibleDevicesController.stream;

  Stream<BleDevice> get pickedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice == null);

  DevicesBloc(this._deviceRepository, this._dbManager);

  _handlePickedDevice(BleDevice bleDevice) =>
      _deviceRepository.pickDevice(bleDevice);

  void init() async {
    if (await _checkPermissions()) {
      bleDevices.clear();
      Future.delayed(Duration(seconds: 2),
          () => _checkBluetooth().then((_) => _startScan()));
      // makes sure to reload the devices if fetched after auth process.
      if (_visibleDevicesController.isClosed)
        _visibleDevicesController =
            BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);
    }
  }

  Future<bool> _checkPermissions() async {
    locationPerm.PermissionStatus permissionStatus =
        await locationPerm.LocationPermissions().checkPermissionStatus();
    if (permissionStatus != locationPerm.PermissionStatus.granted) {
      final status =
          await locationPerm.LocationPermissions().requestPermissions();
      if (status == locationPerm.PermissionStatus.granted ||
          status == locationPerm.PermissionStatus.restricted) {
        return true;
      } else
        return false;
    } else if (!await Location().serviceEnabled()) {
      return Location().requestService();
      ;
    }
    return true;
    ;
  }

  Future<void> _checkBluetooth() async {
    if (await _bleManager.bluetoothState() != BluetoothState.POWERED_ON)
      await _bleManager.enableRadio();
  }

  @override
  create() {
    streamSubscription = stream.listen(_handlePickedDevice);
    _pickedDevicesSubscription = this.pickedDevice.listen((device) {
      if (device != null) {
        $<PageManager>().openBleAuth();
      }
    });
  }

  @override
  pause() {
    _pickedDevicesSubscription.pause();
    _stopScan();
  }

  @override
  resume() {
    init();
    _pickedDevicesSubscription?.resume();
  }

  @override
  dispose() {
    super.dispose();
    logger.wtf('Closing stream in DevicesBloc');
    _pickedDevicesSubscription?.cancel();
    _visibleDevicesController.close();
    _scanSubscription?.cancel();
    _stopScan();
  }
}

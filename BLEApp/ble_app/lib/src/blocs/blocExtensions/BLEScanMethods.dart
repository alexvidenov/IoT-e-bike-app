part of '../devicesBloc.dart';

extension BLEScanMethods on DevicesBloc {
  _startScan() {
    _loadDevicesFromCache();
    _scanSubscription = _bleManager.startPeripheralScan(
        uuids: [BluetoothUtils.SERVICE_UUID]).listen((ScanResult scanResult) {
      final bleDevice = BleDevice(peripheral: scanResult.peripheral);
      if (scanResult.advertisementData.localName != null &&
          !bleDevices.contains(bleDevice)) {
        bleDevices.add(bleDevice);
        _saveDeviceToCache(bleDevice.name, bleDevice.id);
        _visibleDevicesController.add(bleDevices.sublist(0));
      }
    });
  }

  _loadDevicesFromCache() {
    List<String> cache = _settingsBloc.cachedDevices();
    if (cache != null) {
      List<BleDevice> cachedDevices = cache
          .map((d) => BLECacheModel.fromJson(jsonDecode(d)))
          .map((c) => BleDevice(
              peripheral: BleManager()
                  .createUnsafePeripheral(c.macAddress, name: c.deviceName)))
          .toList();
      bleDevices.addAll(cachedDevices);
      _visibleDevicesController.add(bleDevices.sublist(0));
    }
  }

  _saveDeviceToCache(String deviceName, String macAddress) =>
      _settingsBloc.addDevice(deviceName, macAddress);

  _stopScan() => _bleManager.stopPeripheralScan();

  Future<void> refresh() async {
    _scanSubscription?.cancel();
    await _bleManager.stopPeripheralScan();
    bleDevices.clear();
    _visibleDevicesController.add(bleDevices.sublist(0));
    _startScan();
  }
}

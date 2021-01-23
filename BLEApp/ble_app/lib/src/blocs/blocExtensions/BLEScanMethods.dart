part of '../devicesBloc.dart';

extension BLEScanMethods on DevicesBloc {
  _startScan() async {
    await _loadDevicesFromCache();
    _scanSubscription = _bleManager.startPeripheralScan(
        uuids: [BluetoothUtils.SERVICE_UUID]).listen((ScanResult scanResult) {
      final bleDevice = BleDevice(peripheral: scanResult.peripheral);
      if (scanResult.advertisementData.localName != null &&
          !bleDevices.contains(bleDevice)) {
        bleDevices.add(bleDevice);
        _visibleDevicesController.add(bleDevices.sublist(0));
      }
    });
  }

  _loadDevicesFromCache() async {
    final List<Device> cache = await _dbManager.fetchDevices();
    if (cache != null) {
      List<BleDevice> cachedDevices = cache
          .map((d) => BleDevice(
              peripheral: BleManager()
                  .createUnsafePeripheral(d.macAddress, name: d.name)))
          .toList();
      bleDevices.addAll(cachedDevices);
      _visibleDevicesController.add(bleDevices.sublist(0));
    }
  }

  _stopScan() => _bleManager.stopPeripheralScan();

  Future<void> refresh() async {
    _scanSubscription?.cancel();
    await _bleManager.stopPeripheralScan();
    bleDevices.clear();
    _visibleDevicesController.add(bleDevices.sublist(0));
    _startScan();
  }
}

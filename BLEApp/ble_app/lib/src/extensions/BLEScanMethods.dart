part of '../blocs/devicesBloc.dart';

extension BLEScanMethods on DevicesBloc {
  _startScan() {
    _scanSubscription = _bleManager.startPeripheralScan(
        uuids: [BluetoothUtils.SERVICE_UUID]).listen((ScanResult scanResult) {
      final bleDevice = BleDevice(peripheral: scanResult.peripheral);
      if (scanResult.advertisementData.localName != null &&
          !bleDevices.contains(bleDevice)) {
        bleDevices.add(bleDevice);
        // TODO replace with addEvent which will have state for searching / and stopping scan as well
        _visibleDevicesController.add(bleDevices.sublist(0));
      }
    });
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

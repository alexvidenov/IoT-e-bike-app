part of '../devicesBloc.dart';

extension BLEScanMethods on DevicesBloc {
  _startScan() async {
    await _loadDevicesFromCache(); // after loading these, ignore scanned devices that have mac that is already in the list
    _scanSubscription = _bleManager.startPeripheralScan(
        uuids: [BluetoothUtils.SERVICE_UUID]).listen((scanResult) {
      print('SCAN RESULT NAME: ${scanResult.advertisementData.localName}');
      final bleDevice = BleDevice(peripheral: scanResult.peripheral);
      if (scanResult.advertisementData.localName != null &&
          ((bleDevices.isNotEmpty &&
                  !(bleDevices.singleWhere((d) {
                        print(
                            'D IN LIST ID: ${d.id}...SCANNED ID: ${bleDevice.id}');
                        return d.id == bleDevice.id;
                      }) !=
                      null)) ||
              bleDevices.isEmpty)) {
        print("adding scanned devices");
        bleDevices.add(bleDevice);
        _visibleDevicesController.add(bleDevices.sublist(0));
      }
    });
  }

  _loadDevicesFromCache() async {
    final List<Device> cache = await _dbManager.fetchDevicesForCurrentUser();
    if (cache != null) {
      final List<BleDevice> cachedDevices = cache
          .map((d) => BleDevice(
              peripheral: BleManager()
                  .createUnsafePeripheral(d.macAddress, name: d.name)))
          .where((e) => e.id != null)
          .toList();
      print("adding cached devices");
      cachedDevices.forEach((element) {
        print('${element.name} : ${element.id}');
      });
      bleDevices.addAll(cachedDevices);
      _visibleDevicesController.add(bleDevices.sublist(0));
    }
  }

  Future<void> _stopScan() async => await _bleManager.stopPeripheralScan();

  Future<void> refresh() async {
    _scanSubscription?.cancel();
    await _stopScan();
    bleDevices.clear();
    _visibleDevicesController.add(bleDevices.sublist(0));
    print("starting refreshed scan");
    _startScan();
  }
}

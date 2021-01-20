part of '../deviceBloc.dart';

extension DeviceConnectionMethods on DeviceBloc {
  Future<void> disconnect() =>
      _disconnectManual().then((_) => _deviceRepository.pickDevice(null));

  Future<void> _disconnectManual() async {
    if (await device.value.peripheral.isConnected())
      await _deviceController.stream.value.peripheral
          .disconnectOrCancelConnection();
  }

  Future<void> connect() async {
    try {
      device.listen((bleDevice) async => await bleDevice.peripheral
          .connect()
          .then((_) => _observeConnectionState())
          .then((_) => _deviceRepository.discoverServicesAndStartMonitoring())
          .then((_) => _setDeviceReady.add(true)));
    } catch (e) {
      print('GattException');
    }
  }
}

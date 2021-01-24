part of '../deviceBloc.dart';

typedef AsyncFunction = Future<void> Function();

extension DeviceConnectionMethods on DeviceBloc {
  Future<void> disconnect() =>
      _disconnectManual().then((_) => _deviceRepository.pickDevice(null));

  Future<void> _disconnectManual() async {
    if (await device.value.peripheral.isConnected())
      await _deviceController.stream.value.peripheral
          .disconnectOrCancelConnection();
  }

  Future<void> connect() async => _runWithErrorHandling(() async {
        device.listen((bleDevice) async => await bleDevice.peripheral
            .connect()
            .then((_) => _observeConnectionState())
            .then((_) => _deviceRepository.discoverServicesAndStartMonitoring())
            .then((_) => _setDeviceReady.add(true)));
      });

  Future<void> _runWithErrorHandling(AsyncFunction asyncFunction) async {
    // todo: extract in handler object
    try {
      await asyncFunction();
    } on BleError catch (e) {
      _connectionEvent.add(DeviceConnectionState.bleException(e: e));
    }
  }
}

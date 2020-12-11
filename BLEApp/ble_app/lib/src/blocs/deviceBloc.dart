part of bloc;

@lazySingleton
class DeviceBloc {
  final BleManager _bleManager;
  final DeviceRepository _deviceRepository;

  BehaviorSubject<bool> _isDeviceReadyController;

  Stream<bool> get deviceReady => _isDeviceReadyController.stream;

  Sink<bool> get _setDeviceReady => _isDeviceReadyController.sink;

  BehaviorSubject<BleDevice> _deviceController;

  ValueStream<BleDevice> get device => _deviceController.stream;

  BehaviorSubject<PeripheralConnectionState> _connectionStateController;

  Stream<PeripheralConnectionState> get connectionState =>
      _connectionStateController.stream;

  Sink<PeripheralConnectionState> get _connectionEvent =>
      _connectionStateController.sink;

  Stream<BleDevice> get disconnectedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice != null);

  DeviceBloc(this._deviceRepository) : this._bleManager = BleManager() {
    final device = _deviceRepository.pickedDevice.value;
    _deviceController = BehaviorSubject<BleDevice>.seeded(device);

    _connectionStateController = BehaviorSubject<PeripheralConnectionState>();
    _isDeviceReadyController = BehaviorSubject<bool>.seeded(false);
  }

  init() => _bleManager.stopPeripheralScan();

  Future<void> disconnect() =>
      _disconnectManual().then((_) => _deviceRepository.pickDevice(null));

  Future<void> _disconnectManual() async {
    if (await device.value.peripheral.isConnected())
      await _deviceController.stream.value.peripheral
          .disconnectOrCancelConnection();
  }

  _observeConnectionState() =>
      device.listen((bleDevice) => bleDevice.peripheral
          .observeConnectionState(
              emitCurrentValue: true, completeOnDisconnect: true)
          .listen((connectionState) => _connectionEvent.add(connectionState)));

  Future<void> connect() async =>
      device.listen((bleDevice) async => await bleDevice.peripheral
          .connect()
          .then((_) => _observeConnectionState())
          .then((_) => _deviceRepository.discoverServicesAndStartMonitoring())
          .then((_) => _setDeviceReady.add(true)));

  dispose() async {
    await _deviceController.drain();
    _deviceController.close();

    await _connectionStateController.drain();
    _connectionStateController.close();

    _isDeviceReadyController.close();
  }
}

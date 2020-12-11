part of bloc;

@injectable
class DevicesBloc extends Bloc<BleDevice, BleDevice> {
  final DeviceRepository _deviceRepository;
  final BleManager _bleManager;

  final List<BleDevice> bleDevices = <BleDevice>[];

  BehaviorSubject<List<BleDevice>> _visibleDevicesController =
      BehaviorSubject<List<BleDevice>>.seeded(<BleDevice>[]);

  StreamSubscription<ScanResult> _scanSubscription;

  ValueStream<List<BleDevice>> get visibleDevices =>
      _visibleDevicesController.stream;

  Stream<BleDevice> get pickedDevice => _deviceRepository.pickedDevice
      .skipWhile((bleDevice) => bleDevice == null);

  DevicesBloc(this._deviceRepository) : this._bleManager = BleManager();

  _handlePickedDevice(BleDevice bleDevice) =>
      _deviceRepository.pickDevice(bleDevice);

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

  _startScan() {
    _scanSubscription = _bleManager.startPeripheralScan(
        uuids: [BluetoothUtils.SERVICE_UUID]).listen((ScanResult scanResult) {
      final bleDevice = BleDevice(peripheral: scanResult.peripheral);
      if (scanResult.advertisementData.localName != null &&
          !bleDevices.contains(bleDevice)) {
        bleDevices.add(bleDevice);
        // TODO: FIX THE PART THAT CRASHES THAT LINE
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

  @override
  dispose() {
    super.dispose();
    _visibleDevicesController.close();
    _scanSubscription?.cancel();
    _stopScan();
  }

  @override
  _create() => streamSubscription = stream.listen(_handlePickedDevice);

  @override
  _pause() => _stopScan();

  @override
  _resume() => init();
}

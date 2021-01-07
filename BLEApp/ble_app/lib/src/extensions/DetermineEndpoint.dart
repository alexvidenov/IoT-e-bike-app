part of '../blocs/entryEndpointBloc.dart';

extension DetermineEndpoint on EntryEndpointBloc {
  _determineEndpoint() {
    String _deviceId = _settingsBloc.getOptionalDeviceId();
    if (_deviceId != 'empty') {
      BleDevice device =
          BleDevice(peripheral: BleManager().createUnsafePeripheral(_deviceId));
      _listen();
      _devicesBloc.init();
      _devicesBloc.create();
      _devicesBloc.addEvent(device);
    } else {
      addEvent(Endpoint.DevicesScreen);
    }
  }
}

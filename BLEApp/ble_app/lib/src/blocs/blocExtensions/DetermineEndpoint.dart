part of '../entryEndpointBloc.dart';

extension DetermineEndpoint on EntryEndpointBloc {
  _determineEndpoint() {
    String _deviceId = _settingsBloc.getOptionalDeviceId();
    if (_deviceId != 'empty') {
      BleDevice device =
          BleDevice(peripheral: BleManager().createUnsafePeripheral(_deviceId));
      _listenForPickedDevice();
      _devicesBloc.init();
      _devicesBloc.create();
      _devicesBloc.addEvent(device);
    } else {
      addEvent(Endpoint.DevicesScreen);
    }
  }
}

part of '../btAuthenticationBloc.dart';

extension BTAuthMethods on BluetoothAuthBloc {
  authenticate(String password) {
    print('AUTHENTICATING');
    _repository.writeToCharacteristic('P$password\r');
  }

  changePassword(String newPassword) =>
      _repository.writeToCharacteristic('W27$newPassword\r');

  changeDeviceName(String deviceName) => _db.updateDeviceName(deviceName);

  Future<bool> checkUserExistsWithDevice(String curDeviceId) async =>
      await _db.fetchUserDevice() != null;
}

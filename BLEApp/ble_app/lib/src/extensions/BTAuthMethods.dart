part of '../blocs/btAuthenticationBloc.dart';

extension BTAuthMethods on BluetoothAuthBloc {
  authenticate(String password) =>
      _repository.writeToCharacteristic('P$password\r');

  changePassword(String newPassword) =>
      _repository.writeToCharacteristic('W27$newPassword\r');

  Future<bool> checkUserExistsWithDevice(
          String serialNumber, String userId) async =>
      await _db.deviceDao.fetchDevice(serialNumber, userId) != null;
}

part of '../blocs/btAuthenticationBloc.dart';

extension BTAuthMethods on BluetoothAuthBloc {
  authenticate(String password) => _repository.writeToCharacteristic(password);

  changePassword(String newPassword) =>
      _repository.writeToCharacteristic(newPassword);

  Future<bool> checkUserExistsWithDevice(
      String serialNumber, String userId) async {
    return await _db.deviceDao.fetchDevice(serialNumber, userId) != null;
  }
}
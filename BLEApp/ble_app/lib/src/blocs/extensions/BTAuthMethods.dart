part of bloc;

extension BTAuthMethods on BluetoothAuthBloc {
  authenticate(String password) => _repository.writeToCharacteristic(password);

  changePassword(String newPassword) =>
      _repository.writeToCharacteristic(newPassword);

  Future<bool> checkUserExistsWithDevice(
      String serialNumber, String userId) async {
    final userId = _auth.getCurrentUserId();
    return await _localDatabase.deviceDao.fetchDevice(serialNumber, userId) !=
        null;
  }
}
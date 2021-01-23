import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/persistence/dao/deviceDao.dart';
import 'package:ble_app/src/persistence/dao/parametersDao.dart';
import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/persistence/entities/user.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalDatabaseManager with CurrentContext {
  final LocalDatabase _localDatabase;

  UserDao get _userDao => _localDatabase.userDao;

  DeviceDao get _deviceDao => _localDatabase.deviceDao;

  ParametersDao get _parametersDao => _localDatabase.parametersDao;

  const LocalDatabaseManager(this._localDatabase);

  insertUser(User user) => _userDao.insertEntity(user);

  insertDevice(Device device) => _deviceDao.insertEntity(device);

  insertParameters(DeviceParameters parameters) =>
      _parametersDao.insertEntity(parameters);

  Future<Device> fetchDevice() async =>
      await _deviceDao.fetchDevice(this.curDeviceId, this.curUserId);

  Future<List<Device>> fetchDevices() async =>
      await _deviceDao.fetchDevices(this.curUserId);

  Stream<DeviceParameters> fetchParameters() =>
      _parametersDao.fetchDeviceParameters(this.curDeviceId);

  updateParameter(DeviceParameters parameters) =>
      _parametersDao.updateEntity(parameters);

  setMacAddress(String mac) => _deviceDao.setMacAddress(mac, this.curDeviceId);

  updateChangedParameters(String parameters) =>
      _deviceDao.updateParametersToChange(parameters, this.curDeviceId);
}

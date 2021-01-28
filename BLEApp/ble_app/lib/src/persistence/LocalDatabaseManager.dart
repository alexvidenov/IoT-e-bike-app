import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/persistence/dao/deviceDao.dart';
import 'package:ble_app/src/persistence/dao/parametersDao.dart';
import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/persistence/entities/user.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/utils/bluetoothUtils.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalDatabaseManager with CurrentContext {
  final LocalDatabase _localDatabase;

  UserDao get _userDao => _localDatabase.userDao;

  DeviceDao get _deviceDao => _localDatabase.deviceDao;

  ParametersDao get _parametersDao => _localDatabase.parametersDao;

  const LocalDatabaseManager(this._localDatabase);

  insertUser(User user) => _userDao.insertEntity(user);

  deleteAnonymousUser() => _userDao.deleteUser('anonymous');

  insertDevice(Device device) => _deviceDao.insertEntity(device);

  insertParameters(DeviceParameters parameters) =>
      _parametersDao.insertEntity(parameters);

  Future<User> fetchUser(String email) async => await _userDao.fetchUser(email);

  Future<Device> fetchDevice() async =>
      await _deviceDao.fetchDevice(this.curDeviceId, this.curUserId);

  Future<List<Device>> fetchDevices() async =>
      await _deviceDao.fetchDevices(curUserId);

  Stream<DeviceParameters> fetchParameters() =>
      _parametersDao.fetchDeviceParameters(this.curDeviceId);

  updateParameter(DeviceParameters parameters) =>
      _parametersDao.updateEntity(parameters);

  setMacAddress(String mac) => _deviceDao.setMacAddress(mac, curDeviceId);

  updateChangedParameters(String parameters) =>
      _deviceDao.updateParametersToChange(parameters, this.curDeviceId);

  Future<bool> isAnonymous() async {
    final user = await _userDao.fetchUser('anonymous');
    if (user != null)
      return true;
    else
      return false;
  }

  insertAnonymousUser() =>
      _userDao.insertEntity(User('0000', 'anonymous', 'password'));

  insertAnonymousDevice() => _deviceDao.insertEntity(Device(
      deviceId: '1234',
      // TODO: extract in a separate object these constants
      userId: '0000',
      name: BluetoothUtils.defaultBluetoothDeviceName));
}

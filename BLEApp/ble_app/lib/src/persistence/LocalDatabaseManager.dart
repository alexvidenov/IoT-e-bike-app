import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/persistence/dao/deviceDao.dart';
import 'package:ble_app/src/persistence/dao/parametersDao.dart';
import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/dao/userDevicesDao.dart';
import 'package:ble_app/src/persistence/entities/userDevices.dart';
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

  UserDevicesDao get _userDevicesDao => _localDatabase.userDevicesDao;

  const LocalDatabaseManager(this._localDatabase);

  void insertUser(User user) => _userDao.insertEntity(user);

  void deleteAnonymousUser() => _userDao.deleteUser('anonymous');

  void insertDevice(Device device) => _deviceDao.insertEntity(device);

  void insertUserWithDevice(String userId, String deviceId) =>
      _userDevicesDao.insertEntity(UserDevices(userId, deviceId));

  void insertDevices(List<Device> devices) => _deviceDao.insertList(devices);

  void insertParameters(DeviceParameters parameters) =>
      _parametersDao.insertEntity(parameters);

  void insertListParameters(List<DeviceParameters> parameters) =>
      _parametersDao.insertList(parameters);

  Future<User> fetchUser(String email) async => await _userDao.fetchUser(email);

  Future<Device> fetchUserDevice() async =>
      await _deviceDao.fetchUserDevice(this.curDeviceId, this.curUserId);

  Future<Device> fetchDevice() async =>
      await _deviceDao.fetchDevice(this.curDeviceId);

  Future<List<Device>> fetchDevices() async =>
      await _deviceDao.fetchDevices(curUserId);

  Stream<DeviceParameters> fetchParameters() =>
      _parametersDao.fetchDeviceParametersAsStream(curDeviceId);

  Future<DeviceParameters> fetchParametersAsFuture() async =>
      await _parametersDao.fetchDeviceParametersAsFuture(curDeviceId);

  void updateParameter(DeviceParameters parameters) =>
      _parametersDao.updateEntity(parameters);

  void setMacAddress(String mac) => _deviceDao.setMacAddress(mac, curDeviceId);

  void updateChangedParameters(String parameters) =>
      _deviceDao.updateParametersToChange(parameters, this.curDeviceId);

  Future<bool> userExists(String email) async =>
      await _userDao.fetchUser(email) != null;

  Future<bool> deviceExists(String deviceId) async =>
      await _deviceDao.fetchDevice(deviceId) != null;

  Future<bool> isAnonymous() async =>
      await _userDao.fetchUser('anonymous') != null;

  void insertAnonymousUser() =>
      _userDao.insertEntity(User('0000', 'anonymous', 'password'));

  void insertAnonymousDevice() => _deviceDao.insertEntity(Device(
      deviceId: '1234',
      // TODO: extract in a separate object these constants
      name: BluetoothUtils.defaultBluetoothDeviceName,
      isSuper: false));
}

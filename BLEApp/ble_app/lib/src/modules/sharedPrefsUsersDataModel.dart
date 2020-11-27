import 'package:ble_app/src/modules/logFileModel.dart';

class AppData {
  List<UserData> usersData;

  DeviceLog _currentDeviceLog;

  AppData(
      {List<UserData> usersData, String userId, String deviceSerialNumber}) {
    if (usersData == null) {
      _instantiateCurrentUserWithDevice(userId, deviceSerialNumber);
    } else {
      this.usersData =
          usersData; // in that case we don't even instantiate the currentLog object
      UserData currentUser;
      try {
        currentUser = usersData.firstWhere((user) =>
            user.userId == userId); // make a check for the device as well
      } catch (IterableElementError) {
        currentUser = UserData.fromJson({
          'user': userId,
          'devices': [
            {'id': deviceSerialNumber, 'data': []}
          ]
        });
        usersData.add(currentUser);
      }
      _currentDeviceLog = currentUser.userLog
          .firstWhere((device) => device.deviceId == deviceSerialNumber); // this may throw if the deviceis different
    }
  }

  _instantiateCurrentUserWithDevice(String userId, String deviceSerialNumber) {
    usersData = <UserData>[];
    UserData _currentUser;
    _currentUser = UserData.fromJson({
      'user': userId,
      'devices': [
        {'id': deviceSerialNumber, 'data': []}
      ]
    });
    usersData.add(_currentUser);

    _currentDeviceLog = _currentUser.userLog
        .firstWhere((device) => device.deviceId == deviceSerialNumber);
  }

  factory AppData.fromJson(List<dynamic> json,
      {String userId, String deviceSerialNumber}) {
    List<UserData> data = <UserData>[];
    data = json.map((user) => UserData.fromJson(user)).toList();
    return AppData(
        usersData: data,
        userId: userId,
        deviceSerialNumber: deviceSerialNumber);
  }

  List<dynamic> toJson() => usersData.map((user) => user.toJson()).toList();

  addCurrentRecord(Map<String, dynamic> data) => _currentDeviceLog.addLog(data);
}

class UserData {
  final String userId;
  List<DeviceLog> userLog;

  UserData({this.userId, this.userLog});

  addLog(Map<String, dynamic> data) => userLog.add(DeviceLog.fromJson(data));

  Map<String, dynamic> toJson() =>
      {'user': userId, 'devices': userLog.map((log) => log.toJson()).toList()};

  factory UserData.fromJson(Map<String, dynamic> json) {
    List<dynamic> devices = json['devices'];
    List<DeviceLog> list = List();
    list = devices.map((log) => DeviceLog.fromJson(log)).toList();
    return UserData(userId: json['user'], userLog: list);
  }
}

class DeviceLog {
  String deviceId;
  List<LogModel> deviceLog;

  DeviceLog({this.deviceId, this.deviceLog});

  addLog(Map<String, dynamic> data) => deviceLog.add(LogModel.fromJson(data));

  factory DeviceLog.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = json['data'];
    List<LogModel> devicesLog = [];
    devicesLog = data.map((log) => LogModel.fromJson(log)).toList();
    return DeviceLog(deviceId: json['id'], deviceLog: devicesLog);
  }

  Map<String, dynamic> toJson() =>
      {'id': deviceId, 'data': deviceLog.map((log) => log.toJson()).toList()};
}

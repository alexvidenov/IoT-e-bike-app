import 'package:ble_app/src/modules/logFileModel.dart';

class AppData {
  final List<UserData> usersData;

  const AppData({this.usersData});

  factory AppData.fromJson(List<dynamic> json) {
    List<UserData> data = new List<UserData>();
    data = json.map((user) => UserData.fromJson(user)).toList();
    return AppData(usersData: data);
  }
}

class UserData {
  final String userId;
  List<DeviceLog> userLog;

  UserData({this.userId, this.userLog});

  addLog(DeviceLog log) => userLog.add(log);

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

  addLog(LogModel log) => deviceLog.add(log);

  factory DeviceLog.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = json['data'];
    List<LogModel> devicesLog = List();
    devicesLog = data.map((log) => LogModel.fromJson(log)).toList();
    return DeviceLog(deviceId: json['id'], deviceLog: devicesLog);
  }
}

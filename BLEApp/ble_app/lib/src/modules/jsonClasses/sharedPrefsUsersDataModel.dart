import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sharedPrefsUsersDataModel.g.dart';

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
            user.userId ==
            userId); // make a check for the device as well. THIS FAILS WHEN USER SIGNS AGAIN, EVEN HE IS ALREADY REGISTERED
      } catch (IterableElementError) {
        currentUser = UserData.fromJson({
          // AND IT WILL EVENTUALLY GET HERE AND INSTANTIATE USER WITH NULL..THAT'S WHY
          'user': userId,
          'devices': [
            {'id': deviceSerialNumber, 'data': []}
            // NULL FOLDER COMES FROM HERE
          ]
        });
        usersData.add(currentUser);
      }
      DeviceLog deviceLog;
      try {
        // case if the same user logs in with different device
        deviceLog = currentUser.userLog
            .firstWhere((device) => device.deviceId == deviceSerialNumber);
      } catch (IterableElementError) {
        deviceLog = DeviceLog.fromJson({'id': deviceSerialNumber, 'data': []});
        currentUser.addLog(deviceLog);
      }
      _currentDeviceLog = deviceLog;
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
      // here, we pass only the json, and if the user does not exist, user is not even created
      {String userId,
      String deviceSerialNumber}) {
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

@JsonSerializable(nullable: false)
class UserData {
  // TODO: abstract in other class
  @JsonKey(name: 'user')
  final String userId;

  @JsonKey(name: 'devices')
  List<DeviceLog> userLog;

  UserData({this.userId, this.userLog});

  addLog(DeviceLog deviceLog) => userLog.add(deviceLog);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

@JsonSerializable(nullable: false)
class DeviceLog {
  @JsonKey(name: 'id')
  String deviceId;

  @JsonKey(name: 'data')
  List<LogModel> deviceLog;

  DeviceLog({this.deviceId, this.deviceLog});

  void addLog(Map<String, dynamic> data) =>
      deviceLog.add(LogModel.fromJson(data));

  factory DeviceLog.fromJson(Map<String, dynamic> json) =>
      _$DeviceLogFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceLogToJson(this);
}

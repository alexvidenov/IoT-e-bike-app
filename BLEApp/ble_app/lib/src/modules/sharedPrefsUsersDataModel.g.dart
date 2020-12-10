// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharedPrefsUsersDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    userId: json['user'] as String,
    userLog: (json['devices'] as List)
        .map((e) => DeviceLog.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'user': instance.userId,
      'devices': instance.userLog,
    };

DeviceLog _$DeviceLogFromJson(Map<String, dynamic> json) {
  return DeviceLog(
    deviceId: json['id'] as String,
    deviceLog: (json['data'] as List)
        .map((e) => LogModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$DeviceLogToJson(DeviceLog instance) => <String, dynamic>{
      'id': instance.deviceId,
      'data': instance.deviceLog,
    };

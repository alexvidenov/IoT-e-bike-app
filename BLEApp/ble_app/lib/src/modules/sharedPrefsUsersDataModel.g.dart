// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharedPrefsUsersDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    userId: json['userId'] as String,
    userLog: (json['userLog'] as List)
        ?.map((e) =>
            e == null ? null : DeviceLog.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'userId': instance.userId,
      'userLog': instance.userLog,
    };

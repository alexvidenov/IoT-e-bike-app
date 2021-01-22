// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bleCacheModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BLECacheModel _$BLECacheModelFromJson(Map<String, dynamic> json) {
  return BLECacheModel(
    deviceName: json['name'] as String,
    macAddress: json['address'] as String,
  );
}

Map<String, dynamic> _$BLECacheModelToJson(BLECacheModel instance) =>
    <String, dynamic>{
      'name': instance.deviceName,
      'address': instance.macAddress,
    };

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bleCacheModel.g.dart';

@JsonSerializable()
class BLECacheModel{
  @JsonKey(name: 'name')
  final String deviceName;

  @JsonKey(name: 'address')
  final String macAddress;

  const BLECacheModel({this.deviceName, this.macAddress});

  factory BLECacheModel.fromJson(Map<String, dynamic> json) => _$BLECacheModelFromJson(json);

  Map<String, dynamic> toJson() => _$BLECacheModelToJson(this);
}
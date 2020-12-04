// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logFileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatteryStatusModel _$_BatteryStatusModelFromJson(Map<String, dynamic> json) {
  return _BatteryStatusModel(
    voltage: (json['voltage'] as num)?.toDouble(),
    temp: (json['temp'] as num)?.toDouble(),
    currentCharge: (json['currentCharge'] as num)?.toDouble(),
    currentDischarge: (json['currentDischarge'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_BatteryStatusModelToJson(
        _BatteryStatusModel instance) =>
    <String, dynamic>{
      'voltage': instance.voltage,
      'temp': instance.temp,
      'currentCharge': instance.currentCharge,
      'currentDischarge': instance.currentDischarge,
    };

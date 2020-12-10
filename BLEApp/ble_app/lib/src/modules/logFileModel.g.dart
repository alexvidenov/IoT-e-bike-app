// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logFileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatteryStatusModel _$_BatteryStatusModelFromJson(Map<String, dynamic> json) {
  return _BatteryStatusModel(
    voltage: (json['voltage'] as num).toDouble(),
    temp: (json['temp'] as num).toDouble(),
    currentCharge: (json['currentCharge'] as num).toDouble(),
    currentDischarge: (json['currentDischarge'] as num).toDouble(),
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

LogModel _$LogModelFromJson(Map<String, dynamic> json) {
  return LogModel(
    timeStamp: json['timeStamp'] as String,
    model: _BatteryStatusModel.fromJson(json['stats'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LogModelToJson(LogModel instance) => <String, dynamic>{
      'timeStamp': instance.timeStamp,
      'stats': instance.model,
    };

LogFileModel _$LogFileModelFromJson(Map<String, dynamic> json) {
  return LogFileModel(
    logs: (json['logs'] as List)
        .map((e) => LogModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$LogFileModelToJson(LogFileModel instance) =>
    <String, dynamic>{
      'logs': instance.logs,
    };

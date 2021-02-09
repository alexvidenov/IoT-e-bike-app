// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logFileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogModel _$LogModelFromJson(Map<String, dynamic> json) {
  return LogModel(
    voltage: (json['voltage'] as num)?.toDouble(),
    temp: (json['temp'] as num)?.toDouble(),
    current: (json['current'] as num)?.toDouble(),
    delta: (json['delta'] as num)?.toDouble(),
    timeStamp: json['timeStamp'] as String,
  );
}

Map<String, dynamic> _$LogModelToJson(LogModel instance) => <String, dynamic>{
      'timeStamp': instance.timeStamp,
      'voltage': instance.voltage,
      'current': instance.current,
      'temp': instance.temp,
      'delta': instance.delta,
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

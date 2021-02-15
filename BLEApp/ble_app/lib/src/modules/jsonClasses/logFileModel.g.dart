// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logFileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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

_$ShortLogmodel _$_$ShortLogmodelFromJson(Map<String, dynamic> json) {
  return _$ShortLogmodel(
    timeStamp: json['timeStamp'] as String,
    voltage: (json['voltage'] as num)?.toDouble(),
    current: (json['current'] as num)?.toDouble(),
    temp: json['temp'] as int,
  );
}

Map<String, dynamic> _$_$ShortLogmodelToJson(_$ShortLogmodel instance) =>
    <String, dynamic>{
      'timeStamp': instance.timeStamp,
      'voltage': instance.voltage,
      'current': instance.current,
      'temp': instance.temp,
    };

_$FullLogModel _$_$FullLogModelFromJson(Map<String, dynamic> json) {
  return _$FullLogModel(
    timeStamp: json['timeStamp'] as String,
    voltage: (json['voltage'] as num)?.toDouble(),
    current: (json['current'] as num)?.toDouble(),
    temp: json['temp'] as int,
    delta: (json['delta'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$FullLogModelToJson(_$FullLogModel instance) =>
    <String, dynamic>{
      'timeStamp': instance.timeStamp,
      'voltage': instance.voltage,
      'current': instance.current,
      'temp': instance.temp,
      'delta': instance.delta,
    };

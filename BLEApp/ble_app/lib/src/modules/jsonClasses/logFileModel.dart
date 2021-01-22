import 'package:json_annotation/json_annotation.dart';

part 'logFileModel.g.dart';

@JsonSerializable(nullable: false)
class _BatteryStatusModel {
  final double voltage;
  final double temp;
  final double current;

  const _BatteryStatusModel(
      {this.voltage, this.temp, this.current});

  factory _BatteryStatusModel.fromJson(Map<String, dynamic> json) =>
      _$_BatteryStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$_BatteryStatusModelToJson(this);
}

@JsonSerializable(nullable: false)
class LogModel {
  final String timeStamp;
  
  @JsonKey(name: 'stats')
  final _BatteryStatusModel model;

  const LogModel({this.timeStamp, this.model});

  factory LogModel.fromJson(Map<String, dynamic> json) =>
      _$LogModelFromJson(json);

  Map<String, dynamic> toJson() => _$LogModelToJson(this);
}

@JsonSerializable(nullable: false)
class LogFileModel {
  final List<LogModel> logs;

  const LogFileModel({this.logs});

  factory LogFileModel.fromJson(Map<String, dynamic> json) =>
      _$LogFileModelFromJson(json);
}

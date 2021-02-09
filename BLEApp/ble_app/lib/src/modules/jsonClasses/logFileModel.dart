import 'package:json_annotation/json_annotation.dart';

part 'logFileModel.g.dart';

@JsonSerializable(nullable: true) // TODO: convert to freezed
class LogModel {
  final String timeStamp;
  final double voltage;
  final double current;
  final double temp;
  final double delta;

  const LogModel(
      {this.voltage, this.temp, this.current, this.delta, this.timeStamp});

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

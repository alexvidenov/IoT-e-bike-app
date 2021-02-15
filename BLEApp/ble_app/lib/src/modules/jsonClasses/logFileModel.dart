import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logFileModel.g.dart';

part 'logFileModel.freezed.dart';

@freezed
abstract class LogModel with _$LogModel {
  const factory LogModel.short(
      {String timeStamp,
      double voltage,
      double current,
      int temp}) = ShortLogmodel;

  const factory LogModel.full(
      {String timeStamp,
      double voltage,
      double current,
      int temp,
      double delta}) = FullLogModel;

  factory LogModel.fromJson(Map<String, dynamic> json) =>
      _$LogModelFromJson(json);
}

@JsonSerializable(nullable: false)
class LogFileModel {
  final List<LogModel> logs;

  const LogFileModel({this.logs});

  factory LogFileModel.fromJson(Map<String, dynamic> json) =>
      _$LogFileModelFromJson(json);
}

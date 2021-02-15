import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'BaseModel.dart';

part 'shortStatusModel.freezed.dart';

@freezed
abstract class ShortStatusModel with _$ShortStatusModel {
  @Implements(BaseModel)
  const factory ShortStatusModel(
      {@Default(0) double totalVoltage,
      @Default(0) double current,
      @Default(0) int temperature}) = ShortStatus;
}

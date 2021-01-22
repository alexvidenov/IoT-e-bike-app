import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'shortStatusModel.freezed.dart';

@freezed
abstract class ShortStatusModel with _$ShortStatusModel {
  const factory ShortStatusModel(
      double totalVoltage, double current, double temperature) = _ShortStatus;

  const factory ShortStatusModel.empty(
      [@Default(0) double totalVoltage,
      @Default(0) double current,
      @Default(0) double temperature]) = _EmptyShortStatus;
}

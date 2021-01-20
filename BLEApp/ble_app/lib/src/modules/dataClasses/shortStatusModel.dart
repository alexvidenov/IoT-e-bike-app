import 'package:auto_data/auto_data.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'shortStatusModel.freezed.dart';

@freezed
abstract class ShortStatusModel with _$ShortStatusModel {
  const factory ShortStatusModel(double totalVoltage, double currentCharge,
      double currentDischarge, double temperature) = _ShortStatus;

  const factory ShortStatusModel.empty(
      [@Default(0) double totalVoltage,
      @Default(0) double currentCharge,
      @Default(0) double currentDischarge,
      @Default(0) double temperature]) = _EmptyShortStatus;
}

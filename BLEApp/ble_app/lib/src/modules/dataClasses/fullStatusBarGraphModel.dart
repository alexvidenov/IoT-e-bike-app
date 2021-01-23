import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'fullStatusBarGraphModel.freezed.dart';

@freezed
abstract class FullStatusDataModel with _$FullStatusDataModel {
  const factory FullStatusDataModel({int x, double y, Color color}) =
      _FullStatusDataModel;
}

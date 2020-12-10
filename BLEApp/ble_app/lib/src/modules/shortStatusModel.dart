import 'package:auto_data/auto_data.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

part 'shortStatusModel.g.dart';

@data
class $ShortStatusModel {
  double totalVoltage;
  double currentCharge;
  double currentDischarge;
  double temperature;

  $ShortStatusModel.empty()
      : totalVoltage = 0,
        currentCharge = 0,
        currentDischarge = 0,
        temperature = 0;
}

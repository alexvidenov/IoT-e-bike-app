import 'package:auto_data/auto_data.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

part 'deviceParametersModel.g.dart';

@data
class $DeviceParametersModel {
  int cellCount;

  double maxCellVoltage;
  double maxRecoveryVoltage;
  double balanceCellVoltage;
  double minCellVoltage;
  double minCellRecoveryVoltage;
  double ultraLowCellVoltage;

  double maxTimeLimitedDischargeCurrent;
  double maxCutoffDischargeCurrent;
  int maxCurrentTimeLimitPeriod;
  double maxCutoffChargeCurrent;
  int motoHoursCounterCurrentThreshold;
  int currentCutOffTimerPeriod;

  int maxCutoffTemperature;
  int maxTemperatureRecovery;
  int minTemperatureRecovery;
  int minCutoffTemperature;

  int motoHoursChargeCounter;
  int motoHoursDischargeCounter;
}

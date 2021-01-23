// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deviceParameters.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension DeviceParametersCopyWith on DeviceParameters {
  DeviceParameters copyWith({
    double balanceCellVoltage,
    int cellCount,
    int currentCutOffTimerPeriod,
    String deviceId,
    double maxCellVoltage,
    int maxCurrentTimeLimitPeriod,
    double maxCutoffChargeCurrent,
    double maxCutoffDischargeCurrent,
    int maxCutoffTemperature,
    int maxCutoffTimePeriod,
    double maxRecoveryVoltage,
    int maxTemperatureRecovery,
    double maxTimeLimitedDischargeCurrent,
    double minCellRecoveryVoltage,
    double minCellVoltage,
    int minCutoffTemperature,
    int minTemperatureRecovery,
    int motoHoursChargeCounter,
    int motoHoursCounterCurrentThreshold,
    int motoHoursDischargeCounter,
    double ultraLowCellVoltage,
  }) {
    return DeviceParameters(
      balanceCellVoltage: balanceCellVoltage ?? this.balanceCellVoltage,
      cellCount: cellCount ?? this.cellCount,
      currentCutOffTimerPeriod:
          currentCutOffTimerPeriod ?? this.currentCutOffTimerPeriod,
      maxCellVoltage: maxCellVoltage ?? this.maxCellVoltage,
      maxCurrentTimeLimitPeriod:
          maxCurrentTimeLimitPeriod ?? this.maxCurrentTimeLimitPeriod,
      maxCutoffChargeCurrent:
          maxCutoffChargeCurrent ?? this.maxCutoffChargeCurrent,
      maxCutoffDischargeCurrent:
          maxCutoffDischargeCurrent ?? this.maxCutoffDischargeCurrent,
      maxCutoffTemperature: maxCutoffTemperature ?? this.maxCutoffTemperature,
      maxCutoffTimePeriod: maxCutoffTimePeriod ?? this.maxCutoffTimePeriod,
      maxRecoveryVoltage: maxRecoveryVoltage ?? this.maxRecoveryVoltage,
      maxTemperatureRecovery:
          maxTemperatureRecovery ?? this.maxTemperatureRecovery,
      maxTimeLimitedDischargeCurrent:
          maxTimeLimitedDischargeCurrent ?? this.maxTimeLimitedDischargeCurrent,
      minCellRecoveryVoltage:
          minCellRecoveryVoltage ?? this.minCellRecoveryVoltage,
      minCellVoltage: minCellVoltage ?? this.minCellVoltage,
      minCutoffTemperature: minCutoffTemperature ?? this.minCutoffTemperature,
      minTemperatureRecovery:
          minTemperatureRecovery ?? this.minTemperatureRecovery,
      motoHoursChargeCounter:
          motoHoursChargeCounter ?? this.motoHoursChargeCounter,
      motoHoursCounterCurrentThreshold: motoHoursCounterCurrentThreshold ??
          this.motoHoursCounterCurrentThreshold,
      motoHoursDischargeCounter:
          motoHoursDischargeCounter ?? this.motoHoursDischargeCounter,
      ultraLowCellVoltage: ultraLowCellVoltage ?? this.ultraLowCellVoltage,
    );
  }
}

import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:floor/floor.dart';

import 'package:flutter/material.dart';

import 'model.dart';

@Entity(tableName: "parameters", foreignKeys: [
  ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Device,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade)
])
class DeviceParameters extends Model {
  final int cellCount;
  final double maxCellVoltage;
  final double maxRecoveryVoltage;
  final double balanceCellVoltage;
  final double minCellVoltage;
  final double minCellRecoveryVoltage;
  final double ultraLowCellVoltage;
  final double maxTimeLimitedDischargeCurrent;
  final double maxCutoffDischargeCurrent;
  final int maxCurrentTimeLimitPeriod;
  final double maxCutoffChargeCurrent;
  final int motoHoursCounterCurrentThreshold;
  final int currentCutOffTimerPeriod;
  final int maxCutoffTemperature;
  final int maxTemperatureRecovery;
  final int minTemperatureRecovery;
  final int minCutoffTemperature;
  final int motoHoursChargeCounter;
  final int motoHoursDischargeCounter;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const DeviceParameters({
    @required String id,
    @required this.cellCount,
    @required this.maxCellVoltage,
    @required this.maxRecoveryVoltage,
    @required this.balanceCellVoltage,
    @required this.minCellVoltage,
    @required this.minCellRecoveryVoltage,
    @required this.ultraLowCellVoltage,
    @required this.maxTimeLimitedDischargeCurrent,
    @required this.maxCutoffDischargeCurrent,
    @required this.maxCurrentTimeLimitPeriod,
    @required this.maxCutoffChargeCurrent,
    @required this.motoHoursCounterCurrentThreshold,
    @required this.currentCutOffTimerPeriod,
    @required this.maxCutoffTemperature,
    @required this.maxTemperatureRecovery,
    @required this.minTemperatureRecovery,
    @required this.minCutoffTemperature,
    @required this.motoHoursChargeCounter,
    @required this.motoHoursDischargeCounter,
  }) : super(id: id);

  DeviceParameters copyWith({
    int cellCount,
    double maxCellVoltage,
    double maxRecoveryVoltage,
    double balanceCellVoltage,
    double minCellVoltage,
    double minCellRecoveryVoltage,
    double ultraLowCellVoltage,
    double maxTimeLimitedDischargeCurrent,
    double maxCutoffDischargeCurrent,
    int maxCurrentTimeLimitPeriod,
    double maxCutoffChargeCurrent,
    int motoHoursCounterCurrentThreshold,
    int currentCutOffTimerPeriod,
    int maxCutoffTemperature,
    int maxTemperatureRecovery,
    int minTemperatureRecovery,
    int minCutoffTemperature,
    int motoHoursChargeCounter,
    int motoHoursDischargeCounter,
  }) {
    if ((cellCount == null || identical(cellCount, this.cellCount)) &&
        (maxCellVoltage == null ||
            identical(maxCellVoltage, this.maxCellVoltage)) &&
        (maxRecoveryVoltage == null ||
            identical(maxRecoveryVoltage, this.maxRecoveryVoltage)) &&
        (balanceCellVoltage == null ||
            identical(balanceCellVoltage, this.balanceCellVoltage)) &&
        (minCellVoltage == null ||
            identical(minCellVoltage, this.minCellVoltage)) &&
        (minCellRecoveryVoltage == null ||
            identical(minCellRecoveryVoltage, this.minCellRecoveryVoltage)) &&
        (ultraLowCellVoltage == null ||
            identical(ultraLowCellVoltage, this.ultraLowCellVoltage)) &&
        (maxTimeLimitedDischargeCurrent == null ||
            identical(maxTimeLimitedDischargeCurrent,
                this.maxTimeLimitedDischargeCurrent)) &&
        (maxCutoffDischargeCurrent == null ||
            identical(
                maxCutoffDischargeCurrent, this.maxCutoffDischargeCurrent)) &&
        (maxCurrentTimeLimitPeriod == null ||
            identical(
                maxCurrentTimeLimitPeriod, this.maxCurrentTimeLimitPeriod)) &&
        (maxCutoffChargeCurrent == null ||
            identical(maxCutoffChargeCurrent, this.maxCutoffChargeCurrent)) &&
        (motoHoursCounterCurrentThreshold == null ||
            identical(motoHoursCounterCurrentThreshold,
                this.motoHoursCounterCurrentThreshold)) &&
        (currentCutOffTimerPeriod == null ||
            identical(
                currentCutOffTimerPeriod, this.currentCutOffTimerPeriod)) &&
        (maxCutoffTemperature == null ||
            identical(maxCutoffTemperature, this.maxCutoffTemperature)) &&
        (maxTemperatureRecovery == null ||
            identical(maxTemperatureRecovery, this.maxTemperatureRecovery)) &&
        (minTemperatureRecovery == null ||
            identical(minTemperatureRecovery, this.minTemperatureRecovery)) &&
        (minCutoffTemperature == null ||
            identical(minCutoffTemperature, this.minCutoffTemperature)) &&
        (motoHoursChargeCounter == null ||
            identical(motoHoursChargeCounter, this.motoHoursChargeCounter)) &&
        (motoHoursDischargeCounter == null ||
            identical(
                motoHoursDischargeCounter, this.motoHoursDischargeCounter))) {
      return this;
    }

    return new DeviceParameters(
      id: this.id,
      cellCount: cellCount ?? this.cellCount,
      maxCellVoltage: maxCellVoltage ?? this.maxCellVoltage,
      maxRecoveryVoltage: maxRecoveryVoltage ?? this.maxRecoveryVoltage,
      balanceCellVoltage: balanceCellVoltage ?? this.balanceCellVoltage,
      minCellVoltage: minCellVoltage ?? this.minCellVoltage,
      minCellRecoveryVoltage:
          minCellRecoveryVoltage ?? this.minCellRecoveryVoltage,
      ultraLowCellVoltage: ultraLowCellVoltage ?? this.ultraLowCellVoltage,
      maxTimeLimitedDischargeCurrent:
          maxTimeLimitedDischargeCurrent ?? this.maxTimeLimitedDischargeCurrent,
      maxCutoffDischargeCurrent:
          maxCutoffDischargeCurrent ?? this.maxCutoffDischargeCurrent,
      maxCurrentTimeLimitPeriod:
          maxCurrentTimeLimitPeriod ?? this.maxCurrentTimeLimitPeriod,
      maxCutoffChargeCurrent:
          maxCutoffChargeCurrent ?? this.maxCutoffChargeCurrent,
      motoHoursCounterCurrentThreshold: motoHoursCounterCurrentThreshold ??
          this.motoHoursCounterCurrentThreshold,
      currentCutOffTimerPeriod:
          currentCutOffTimerPeriod ?? this.currentCutOffTimerPeriod,
      maxCutoffTemperature: maxCutoffTemperature ?? this.maxCutoffTemperature,
      maxTemperatureRecovery:
          maxTemperatureRecovery ?? this.maxTemperatureRecovery,
      minTemperatureRecovery:
          minTemperatureRecovery ?? this.minTemperatureRecovery,
      minCutoffTemperature: minCutoffTemperature ?? this.minCutoffTemperature,
      motoHoursChargeCounter:
          motoHoursChargeCounter ?? this.motoHoursChargeCounter,
      motoHoursDischargeCounter:
          motoHoursDischargeCounter ?? this.motoHoursDischargeCounter,
    );
  }

  @override
  String toString() {
    return 'DeviceParameters{cellCount: $cellCount, maxCellVoltage: $maxCellVoltage, maxRecoveryVoltage: $maxRecoveryVoltage, balanceCellVoltage: $balanceCellVoltage, minCellVoltage: $minCellVoltage, minCellRecoveryVoltage: $minCellRecoveryVoltage, ultraLowCellVoltage: $ultraLowCellVoltage, maxTimeLimitedDischargeCurrent: $maxTimeLimitedDischargeCurrent, maxCutoffDischargeCurrent: $maxCutoffDischargeCurrent, maxCurrentTimeLimitPeriod: $maxCurrentTimeLimitPeriod, maxCutoffChargeCurrent: $maxCutoffChargeCurrent, motoHoursCounterCurrentThreshold: $motoHoursCounterCurrentThreshold, currentCutOffTimerPeriod: $currentCutOffTimerPeriod, maxCutoffTemperature: $maxCutoffTemperature, maxTemperatureRecovery: $maxTemperatureRecovery, minTemperatureRecovery: $minTemperatureRecovery, minCutoffTemperature: $minCutoffTemperature, motoHoursChargeCounter: $motoHoursChargeCounter, motoHoursDischargeCounter: $motoHoursDischargeCounter}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceParameters &&
          runtimeType == other.runtimeType &&
          cellCount == other.cellCount &&
          maxCellVoltage == other.maxCellVoltage &&
          maxRecoveryVoltage == other.maxRecoveryVoltage &&
          balanceCellVoltage == other.balanceCellVoltage &&
          minCellVoltage == other.minCellVoltage &&
          minCellRecoveryVoltage == other.minCellRecoveryVoltage &&
          ultraLowCellVoltage == other.ultraLowCellVoltage &&
          maxTimeLimitedDischargeCurrent ==
              other.maxTimeLimitedDischargeCurrent &&
          maxCutoffDischargeCurrent == other.maxCutoffDischargeCurrent &&
          maxCurrentTimeLimitPeriod == other.maxCurrentTimeLimitPeriod &&
          maxCutoffChargeCurrent == other.maxCutoffChargeCurrent &&
          motoHoursCounterCurrentThreshold ==
              other.motoHoursCounterCurrentThreshold &&
          currentCutOffTimerPeriod == other.currentCutOffTimerPeriod &&
          maxCutoffTemperature == other.maxCutoffTemperature &&
          maxTemperatureRecovery == other.maxTemperatureRecovery &&
          minTemperatureRecovery == other.minTemperatureRecovery &&
          minCutoffTemperature == other.minCutoffTemperature &&
          motoHoursChargeCounter == other.motoHoursChargeCounter &&
          motoHoursDischargeCounter == other.motoHoursDischargeCounter);

  @override
  int get hashCode =>
      cellCount.hashCode ^
      maxCellVoltage.hashCode ^
      maxRecoveryVoltage.hashCode ^
      balanceCellVoltage.hashCode ^
      minCellVoltage.hashCode ^
      minCellRecoveryVoltage.hashCode ^
      ultraLowCellVoltage.hashCode ^
      maxTimeLimitedDischargeCurrent.hashCode ^
      maxCutoffDischargeCurrent.hashCode ^
      maxCurrentTimeLimitPeriod.hashCode ^
      maxCutoffChargeCurrent.hashCode ^
      motoHoursCounterCurrentThreshold.hashCode ^
      currentCutOffTimerPeriod.hashCode ^
      maxCutoffTemperature.hashCode ^
      maxTemperatureRecovery.hashCode ^
      minTemperatureRecovery.hashCode ^
      minCutoffTemperature.hashCode ^
      motoHoursChargeCounter.hashCode ^
      motoHoursDischargeCounter.hashCode;

  factory DeviceParameters.fromMap(Map<String, dynamic> map) =>
      new DeviceParameters(
        cellCount: map['00'] as int,
        maxCellVoltage: map['01'] as double,
        maxRecoveryVoltage: map['02'] as double,
        balanceCellVoltage: map['03'] as double,
        minCellVoltage: map['04'] as double,
        minCellRecoveryVoltage: map['05'] as double,
        ultraLowCellVoltage: map['06'] as double,
        maxTimeLimitedDischargeCurrent: map['12'] as double,
        maxCutoffDischargeCurrent: map['13'] as double,
        maxCurrentTimeLimitPeriod: map['14'] as int,
        maxCutoffChargeCurrent: map['15'] as double,
        motoHoursCounterCurrentThreshold: map['16'] as int,
        currentCutOffTimerPeriod: map['17'] as int,
        maxCutoffTemperature: map['23'] as int,
        maxTemperatureRecovery: map['24'] as int,
        minTemperatureRecovery: map['25'] as int,
        minCutoffTemperature: map['26'] as int,
        motoHoursChargeCounter: map['28'] as int,
        motoHoursDischargeCounter: map['29'] as int,
        id: map['45'],
      );

  Map<String, dynamic> toMap() => {
        '00': this.cellCount,
        '01': this.maxCellVoltage,
        '02': this.maxRecoveryVoltage,
        '03': this.balanceCellVoltage,
        '04': this.minCellVoltage,
        '05': this.minCellRecoveryVoltage,
        '06': this.ultraLowCellVoltage,
        '12': this.maxTimeLimitedDischargeCurrent,
        '13': this.maxCutoffDischargeCurrent,
        '14': this.maxCurrentTimeLimitPeriod,
        '15': this.maxCutoffChargeCurrent,
        '16': this.motoHoursCounterCurrentThreshold,
        '17': this.currentCutOffTimerPeriod,
        '23': this.maxCutoffTemperature,
        '24': this.maxTemperatureRecovery,
        '25': this.minTemperatureRecovery,
        '26': this.minCutoffTemperature,
        '28': this.motoHoursChargeCounter,
        '29': this.motoHoursDischargeCounter,
        '45': this.id
      };

//</editor-fold>

}

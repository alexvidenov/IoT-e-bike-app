// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deviceParametersModel.dart';

// **************************************************************************
// AutoDataGenerator
// **************************************************************************

@immutable
class DeviceParametersModel {
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

  const DeviceParametersModel({
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
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceParametersModel &&
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
          motoHoursDischargeCounter == other.motoHoursDischargeCounter;

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

  @override
  String toString() {
    return 'DeviceParametersModel{cellCount: ' +
        cellCount.toString() +
        ', maxCellVoltage: ' +
        maxCellVoltage.toString() +
        ', maxRecoveryVoltage: ' +
        maxRecoveryVoltage.toString() +
        ', balanceCellVoltage: ' +
        balanceCellVoltage.toString() +
        ', minCellVoltage: ' +
        minCellVoltage.toString() +
        ', minCellRecoveryVoltage: ' +
        minCellRecoveryVoltage.toString() +
        ', ultraLowCellVoltage: ' +
        ultraLowCellVoltage.toString() +
        ', maxTimeLimitedDischargeCurrent: ' +
        maxTimeLimitedDischargeCurrent.toString() +
        ', maxCutoffDischargeCurrent: ' +
        maxCutoffDischargeCurrent.toString() +
        ', maxCurrentTimeLimitPeriod: ' +
        maxCurrentTimeLimitPeriod.toString() +
        ', maxCutoffChargeCurrent: ' +
        maxCutoffChargeCurrent.toString() +
        ', motoHoursCounterCurrentThreshold: ' +
        motoHoursCounterCurrentThreshold.toString() +
        ', currentCutOffTimerPeriod: ' +
        currentCutOffTimerPeriod.toString() +
        ', maxCutoffTemperature: ' +
        maxCutoffTemperature.toString() +
        ', maxTemperatureRecovery: ' +
        maxTemperatureRecovery.toString() +
        ', minTemperatureRecovery: ' +
        minTemperatureRecovery.toString() +
        ', minCutoffTemperature: ' +
        minCutoffTemperature.toString() +
        ', motoHoursChargeCounter: ' +
        motoHoursChargeCounter.toString() +
        ', motoHoursDischargeCounter: ' +
        motoHoursDischargeCounter.toString() +
        '}';
  }

  DeviceParametersModel copyWith({
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
    return DeviceParametersModel(
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

  DeviceParametersModel.fromMap(Map<String, dynamic> m)
      : cellCount = m['cellCount'],
        maxCellVoltage = m['maxCellVoltage'],
        maxRecoveryVoltage = m['maxRecoveryVoltage'],
        balanceCellVoltage = m['balanceCellVoltage'],
        minCellVoltage = m['minCellVoltage'],
        minCellRecoveryVoltage = m['minCellRecoveryVoltage'],
        ultraLowCellVoltage = m['ultraLowCellVoltage'],
        maxTimeLimitedDischargeCurrent = m['maxTimeLimitedDischargeCurrent'],
        maxCutoffDischargeCurrent = m['maxCutoffDischargeCurrent'],
        maxCurrentTimeLimitPeriod = m['maxCurrentTimeLimitPeriod'],
        maxCutoffChargeCurrent = m['maxCutoffChargeCurrent'],
        motoHoursCounterCurrentThreshold =
            m['motoHoursCounterCurrentThreshold'],
        currentCutOffTimerPeriod = m['currentCutOffTimerPeriod'],
        maxCutoffTemperature = m['maxCutoffTemperature'],
        maxTemperatureRecovery = m['maxTemperatureRecovery'],
        minTemperatureRecovery = m['minTemperatureRecovery'],
        minCutoffTemperature = m['minCutoffTemperature'],
        motoHoursChargeCounter = m['motoHoursChargeCounter'],
        motoHoursDischargeCounter = m['motoHoursDischargeCounter'];

  Map<String, dynamic> toMap() => {
        'cellCount': cellCount,
        'maxCellVoltage': maxCellVoltage,
        'maxRecoveryVoltage': maxRecoveryVoltage,
        'balanceCellVoltage': balanceCellVoltage,
        'minCellVoltage': minCellVoltage,
        'minCellRecoveryVoltage': minCellRecoveryVoltage,
        'ultraLowCellVoltage': ultraLowCellVoltage,
        'maxTimeLimitedDischargeCurrent': maxTimeLimitedDischargeCurrent,
        'maxCutoffDischargeCurrent': maxCutoffDischargeCurrent,
        'maxCurrentTimeLimitPeriod': maxCurrentTimeLimitPeriod,
        'maxCutoffChargeCurrent': maxCutoffChargeCurrent,
        'motoHoursCounterCurrentThreshold': motoHoursCounterCurrentThreshold,
        'currentCutOffTimerPeriod': currentCutOffTimerPeriod,
        'maxCutoffTemperature': maxCutoffTemperature,
        'maxTemperatureRecovery': maxTemperatureRecovery,
        'minTemperatureRecovery': minTemperatureRecovery,
        'minCutoffTemperature': minCutoffTemperature,
        'motoHoursChargeCounter': motoHoursChargeCounter,
        'motoHoursDischargeCounter': motoHoursDischargeCounter
      };

  factory DeviceParametersModel.fromJson(String json) =>
      DeviceParametersModel.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());
}

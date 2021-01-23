import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:floor/floor.dart';

import 'model.dart';

@Entity(tableName: 'parameters', foreignKeys: [
  ForeignKey(childColumns: ['id'], parentColumns: ['id'], entity: Device)
])
class DeviceParameters extends Model {
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

  DeviceParameters(
      int deviceId,
      this.cellCount,
      this.maxCellVoltage,
      this.maxRecoveryVoltage,
      this.balanceCellVoltage,
      this.minCellVoltage,
      this.minCellRecoveryVoltage,
      this.ultraLowCellVoltage,
      this.maxTimeLimitedDischargeCurrent,
      this.maxCutoffDischargeCurrent,
      this.maxCurrentTimeLimitPeriod,
      this.maxCutoffChargeCurrent,
      this.motoHoursCounterCurrentThreshold,
      this.currentCutOffTimerPeriod,
      this.maxCutoffTemperature,
      this.maxTemperatureRecovery,
      this.minTemperatureRecovery,
      this.motoHoursChargeCounter,
      this.motoHoursDischargeCounter)
      : super(id: deviceId);
}

import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:floor/floor.dart';

import 'model.dart';

part 'deviceParameters.g.dart';

@CopyWith()
@Entity(tableName: "parameters", foreignKeys: [
  ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Device,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade)
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
      {String deviceId,
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
      this.minCutoffTemperature,
      this.motoHoursChargeCounter,
      this.motoHoursDischargeCounter})
      : super(id: deviceId);
}

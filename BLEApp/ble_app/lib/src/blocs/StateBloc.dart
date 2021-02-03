import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/DataCachingManager.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';

abstract class StateBloc<T extends BaseModel>
    extends ParameterAwareBloc<StatusState<T>, String>
    with CurrentContext, DataCachingManager {
  int _scCounter = 0;

  double _lastCurrent;

  StatusState<T> generateState(String rawData) {
    final String status = '${rawData[0]}';
    if (_isDataEmpty(rawData)) {
      return Status(BatteryState.CommunicationLoss);
    }

    final model = generateModel(rawData);
    _lastCurrent = model.current;
    switch (status) {
      case '0':
        return StatusState(
            _isOverDischarge(model.current)
                ? BatteryState.OverDischarge
                : BatteryState.Normal,
            model);
      case '4':
        return StatusState(
            _isOverDischarge(model.current)
                ? BatteryState.OverDischarge
                : BatteryState.UnderVoltageBalance,
            model);
      case '8':
        return StatusState(
            _isOverCharge(model.current)
                ? BatteryState.OverCharge
                : BatteryState.OverVoltage,
            model);
      case 'A':
        return StatusState(BatteryState.LowTemp, model);
      case 'E':
        return StatusState(BatteryState.HighTemp, model);
      case 'C':
        return StatusState(BatteryState.UnderVoltageCritical, model);
      case '2':
        _scCounter++;
        return StatusState(
            _scCounter >= 2 ? BatteryState.ShortCircuit : BatteryState.Unknown,
            model);
      default:
        return StatusState(BatteryState.Unknown, model);
    }
  }

  bool _isOverDischarge(double current) =>
      current < 0 &&
      current >= getParameters().value.maxTimeLimitedDischargeCurrent;

  bool _isOverCharge(double current) =>
      _lastCurrent > 0 &&
      _lastCurrent >= getParameters().value.maxCutoffChargeCurrent;

  bool _isDataEmpty(String rawData) => rawData.length <= 2;

  T generateModel(String rawData);
}

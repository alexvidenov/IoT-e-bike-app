import 'dart:async';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/DataCachingManager.dart';
import 'package:ble_app/src/blocs/OutputControlBloc.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';

abstract class StateBloc<T extends BaseModel>
    extends ParameterAwareBloc<StatusState<T>, String> with DataCachingManager {
  final _controlBloc = $<OutputControlBloc>(); // TODO: use that

  int _scCounter = 0;

  double _lastCurrent = 0;

  Timer _overChargeTimer;

  StatusState<T> generateState(String rawData) {
    final String status = '${rawData[0]}';
    if (_isDataEmpty(rawData)) {
      return Status(BatteryState.CommunicationLoss);
    }
    final model = generateModel(rawData);
    _lastCurrent = model.current;
    print('LAST CURRENT IS $_lastCurrent');
    switch (status) {
      case '0':
        return StatusState(
            _isOverDischarge()
                ? BatteryState
                    .OverDischarge // TODO: add a discharge timer here to indicate the user that he can drive at this state just for a minute or so
                : BatteryState.Normal,
            model);
      case '4':
        return StatusState(
            _isOverDischarge()
                ? BatteryState.OverDischarge
                : BatteryState.LowVoltage,
            model);
      case '8':
        final bool isOC = _isOverCharge();
        if (isOC) {
          if (_overChargeTimer != null && !_overChargeTimer.isActive) {
            _overChargeTimer = Timer(
                Duration(seconds: currentParams.currentCutOffTimerPeriod),
                () {});
            return StatusState(BatteryState.OverCharge, model);
          } else {
            if (_overChargeTimer == null) {
              _overChargeTimer = Timer(
                  Duration(seconds: currentParams.currentCutOffTimerPeriod),
                  () {});
            }
            return StatusState(BatteryState.OverCharge, model);
          }
        } else {
          if (_overChargeTimer.isActive) {
            return StatusState(BatteryState.OverCharge, model);
          } else {
            return StatusState(BatteryState.OverVoltage, model);
          }
        }
        break;
      case 'A':
        return StatusState(BatteryState.LowTemp, model);
      case 'E':
        return StatusState(BatteryState.HighTemp, model);
      case 'C':
        return StatusState(BatteryState.UltraLowVoltage, model);
      case '2':
        _scCounter++;
        return StatusState(
            _scCounter >= 2 ? BatteryState.ShortCircuit : BatteryState.Unknown,
            model);
      default:
        return StatusState(BatteryState.Unknown, model);
    }
  }

  bool _isOverDischarge() {
    double param = currentParams.maxTimeLimitedDischargeCurrent;
    print('DISCHARGE PARAM IS $param');
    return _lastCurrent < 0 && _lastCurrent <= -param;
  }

  bool _isOverCharge() {
    double param = currentParams.maxCutoffChargeCurrent;
    print('CHARGE PARAM IS $param');
    return _lastCurrent > 0 &&
        _lastCurrent >=
            param; // should keep it 10 seconds again. It goes to over voltage because it's still an 8 and the current is 0 at thaat point
  }

  bool _isDataEmpty(String rawData) => rawData.length <= 2;

  T generateModel(String rawData);
}

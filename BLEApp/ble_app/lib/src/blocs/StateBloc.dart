import 'dart:async';

import 'package:ble_app/src/blocs/DataCachingManager.dart';
import 'package:ble_app/src/blocs/LastCurrentTracker.dart';
import 'package:ble_app/src/blocs/OutputControlBloc.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';

abstract class StateBloc<T extends BaseModel>
    extends ParameterAwareBloc<StatusState<T>, String> with DataCachingManager {
  final _controlBloc = $<OutputControlBloc>();
  final _currentTracker = $<OverCurrentTimers>();

  int _scCounter = 0;

  StatusState<T> generateState(String rawData) {
    final String status = '${rawData[0]}';
    if (_isDataEmpty(rawData)) {
      return Status(BatteryState.Error1);
    }
    final model = generateModel(rawData);
    var battState;
    switch (status) {
      case '0':
        // 0 -> count 10 seconds then -> 4 then count 10 seconds again -> 0
        if (_isTimeLimitedOverDischarge()) {
          if (_currentTracker.overDischargeTimeLimited != null &&
                  !_currentTracker.overDischargeTimeLimited.isActive ||
              _currentTracker.overDischargeTimeLimited == null) {
            _currentTracker.overDischargeTimeLimited =
                Timer(Duration(seconds: 10), () {});
          }
          battState = BatteryState.MaxPower;
        } else {
          if (_currentTracker.overDischargeTimeLimited != null &&
              _currentTracker.overDischargeTimeLimited.isActive) {
            _currentTracker.overDischargeTimeLimited.cancel();
          } else
            battState = BatteryState.Normal;
        }
        break; // TODO: add a discharge timer here to indicate the user that he can drive at this state just for a minute or so
      case '4':
        if (_controlBloc.isDeviceManuallyLocked()) {
          battState = BatteryState.Locked;
        } else if (_isTimeLimitedOverDischarge() || _isCutOffOverDischarge()) {
          if (_currentTracker.overDischargeTimer != null &&
                  !_currentTracker.overDischargeTimer.isActive ||
              _currentTracker.overDischargeTimer == null) {
            _currentTracker.overDischargeTimer =
                Timer(Duration(seconds: 10), () {});
          }
          battState = BatteryState.OverCurrent;
        } else {
          if (_currentTracker.overDischargeTimer != null &&
              _currentTracker.overDischargeTimer.isActive) {
            battState = BatteryState.OverCurrent;
          } else {
            battState = BatteryState.LowBatt;
          }
        }
        break;
      case '8':
        if (_isOverCharge()) {
          if (_currentTracker.overChargeTimer != null &&
                  !_currentTracker.overChargeTimer.isActive ||
              _currentTracker.overChargeTimer == null) {
            _currentTracker.overChargeTimer =
                Timer(Duration(seconds: 10), () {});
          }
          battState = BatteryState.OverCharge;
        } else {
          if (_currentTracker.overChargeTimer != null &&
              _currentTracker.overChargeTimer.isActive) {
            battState = BatteryState.OverCharge;
          } else {
            battState = BatteryState.EndOfCharge;
          }
        }
        break;
      case 'A':
        battState = BatteryState.LowTemp;
        break;
      case 'E':
        battState = BatteryState.HighTemp;
        break;
      case 'C':
        battState = BatteryState.Error2;
        break;
      case '2':
        battState = BatteryState.Error3;
        break;
      default:
        battState = BatteryState.Unknown;
        break;
    }
    _currentTracker.current = model.current;
    return StatusState(battState, model);
  }

  bool _isTimeLimitedOverDischarge() {
    double param = currentParams.maxTimeLimitedDischargeCurrent;
    print('DISCHARGE TIME LIMITED PARAM IS $param');
    return _currentTracker.current < 0 && _currentTracker.current <= -param;
  }

  bool _isCutOffOverDischarge() {
    double param = currentParams.maxCutoffDischargeCurrent;
    print('DISCHARGE TIME LIMITED PARAM IS $param');
    return _currentTracker.current < 0 && _currentTracker.current <= -param;
  }

  bool _isOverCharge() {
    double param = currentParams.maxCutoffChargeCurrent;
    print('CHARGE PARAM IS $param');
    return _currentTracker.current > 0 &&
        _currentTracker.current >=
            param; // should keep it 10 seconds again. It goes to over voltage because it's still an 8 and the current is 0 at that point
  }

  bool _isDataEmpty(String rawData) => rawData.length <= 3;

  T generateModel(String rawData);
}

import 'dart:async';

import 'package:ble_app/src/blocs/DataCachingManager.dart';
import 'package:ble_app/src/blocs/OutputControlBloc.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';

abstract class StateBloc<T extends BaseModel>
    extends ParameterAwareBloc<StatusState<T>, String> with DataCachingManager {
  final _controlBloc = $<OutputControlBloc>();

  int _scCounter = 0;

  double _lastCurrent = 0;

  Timer _overChargeTimer;
  Timer _overDischargeTimeLimited;
  Timer _overDischargeTimer;

  StatusState<T> generateState(String rawData) {
    final String status = '${rawData[0]}';
    if (_isDataEmpty(rawData)) {
      return Status(BatteryState.CommunicationLoss);
    }
    final model = generateModel(rawData);
    var battState;
    print('LAST CURRENT IS $_lastCurrent');
    switch (status) {
      case '0':
        if (_overDischargeTimeLimited != null &&
            _overDischargeTimeLimited.isActive) {
          print('OVER DISCHARGE TIME LIMITED ACTIVE');
        }
        // 0 -> count 10 seconds then -> 4 then count 10 seconds again -> 0
        if (_isTimeLimitedOverDischarge()) {
          if (_overDischargeTimeLimited != null &&
              !_overDischargeTimeLimited.isActive) {
            _overDischargeTimeLimited = Timer(Duration(seconds: 10), () {});
          } else {
            if (_overDischargeTimeLimited == null) {
              _overDischargeTimeLimited = Timer(Duration(seconds: 10), () {});
            }
          }
        } else {
          if (_overDischargeTimeLimited != null &&
              _overDischargeTimeLimited.isActive) {
            _overDischargeTimeLimited.cancel();
          }
        }
        battState = BatteryState.Normal;
        break; // TODO: add a discharge timer here to indicate the user that he can drive at this state just for a minute or so
      case '4':
        if (_controlBloc.isDeviceManuallyLocked()) {
          print('MANUALLY LOCKED');
          battState = BatteryState.Normal;
        } else if (_isTimeLimitedOverDischarge() || _isCutOffOverDischarge()) {
          print('TRIGGERED THE DAMN OVER DISCHARGE');
          if (_overDischargeTimer != null && !_overDischargeTimer.isActive) {
            _overDischargeTimer = Timer(Duration(seconds: 10), () {});
            battState = BatteryState.OverDischarge;
          } else {
            if (_overDischargeTimer == null) {
              _overDischargeTimer = Timer(Duration(seconds: 10), () {});
            }
            battState = BatteryState.OverDischarge;
          }
        } else {
          if (_overDischargeTimer != null && _overDischargeTimer.isActive) {
            battState = BatteryState.OverDischarge;
          } else {
            battState = BatteryState.LowVoltage;
          }
        }
        break;
      case '8':
        final bool isOC = _isOverCharge();
        if (isOC) {
          if (_overChargeTimer != null && !_overChargeTimer.isActive) {
            _overChargeTimer = Timer(Duration(seconds: 10), () {});
            battState = BatteryState.OverCharge;
          } else {
            if (_overChargeTimer == null) {
              _overChargeTimer = Timer(Duration(seconds: 10), () {});
            }
            battState = BatteryState.OverCharge;
          }
        } else {
          if (_overChargeTimer != null && _overChargeTimer.isActive) {
            battState = BatteryState.OverCharge;
          } else {
            battState = BatteryState.OverVoltage;
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
        battState = BatteryState.UltraLowVoltage;
        break;
      case '2':
        battState = BatteryState.ShortCircuit;
        break;
      default:
        battState = BatteryState.Unknown;
        break;
    }
    _lastCurrent = model.current;
    return StatusState(battState, model);
  }

  bool _isTimeLimitedOverDischarge() {
    double param = currentParams.maxTimeLimitedDischargeCurrent;
    print('DISCHARGE TIME LIMITED PARAM IS $param');
    return _lastCurrent < 0 && _lastCurrent <= -param;
  }

  bool _isCutOffOverDischarge() {
    double param = currentParams.maxCutoffDischargeCurrent;
    print('DISCHARGE TIME LIMITED PARAM IS $param');
    return _lastCurrent < 0 && _lastCurrent <= -param;
  }

  bool _isOverCharge() {
    double param = currentParams.maxCutoffChargeCurrent;
    print('CHARGE PARAM IS $param');
    return _lastCurrent > 0 &&
        _lastCurrent >=
            param; // should keep it 10 seconds again. It goes to over voltage because it's still an 8 and the current is 0 at that point
  }

  bool _isDataEmpty(String rawData) => rawData.length <= 3;

  T generateModel(String rawData);
}

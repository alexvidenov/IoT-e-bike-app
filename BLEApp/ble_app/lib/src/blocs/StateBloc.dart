import 'dart:async';

import 'package:ble_app/src/blocs/DataCachingManager.dart';
import 'package:ble_app/src/blocs/AbnormalStateTracker.dart';
import 'package:ble_app/src/blocs/OutputControlBloc.dart';
import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';

abstract class StateBloc<T extends BaseModel>
    extends ParameterAwareBloc<StatusState<T>, String> with DataCachingManager {
  final _controlBloc = $<OutputControlBloc>();
  final _abnormalStateTracker = $<AbnormalStateTracker>();

  RxObject<int> get overCurrentTimer => _abnormalStateTracker.timerRx;

  StatusState<T> generateState(String rawData) {
    final String status = '${rawData[0]}';
    if (_isDataEmpty(rawData)) {
      return Status(BatteryState.Error1);
    }
    final model = generateModel(rawData);
    var battState;
    switch (status) {
      case '0':
        if (_abnormalStateTracker.wasSC) _abnormalStateTracker.scCounter = 0;
        if (_isTimeLimitedOverDischarge()) {
          if (_abnormalStateTracker.overDischargeTimeLimited != null &&
                  !_abnormalStateTracker.overDischargeTimeLimited.isActive ||
              _abnormalStateTracker.overDischargeTimeLimited == null) {
            _abnormalStateTracker.seconds = 11;
            _abnormalStateTracker.overDischargeTimeLimited =
                Timer.periodic(const Duration(seconds: 1), (_) {
              _abnormalStateTracker.seconds--;
              this
                  ._abnormalStateTracker
                  .timerRx
                  .addEvent(_abnormalStateTracker.seconds);
              if (_abnormalStateTracker.seconds == 0) {
                _abnormalStateTracker.overDischargeTimeLimited.cancel();
                Future.delayed(Duration(milliseconds: 400),
                    () => _abnormalStateTracker.timerRx.addEvent(-1));
              }
            });
          }
          battState = BatteryState.MaxPower;
        } else {
          if (_abnormalStateTracker.overDischargeTimeLimited != null &&
              _abnormalStateTracker.overDischargeTimeLimited.isActive) {
            _abnormalStateTracker.seconds = 0;
            this
                ._abnormalStateTracker
                .timerRx
                .addEvent(_abnormalStateTracker.seconds);
            _abnormalStateTracker.overDischargeTimeLimited.cancel();
            Future.delayed(Duration(milliseconds: 400),
                () => _abnormalStateTracker.timerRx.addEvent(-1));
          } else
            battState = BatteryState.Normal;
        }
        break;
      case '4':
        if (_abnormalStateTracker.wasSC) _abnormalStateTracker.scCounter = 0;
        if (_controlBloc.isDeviceManuallyLocked()) {
          battState = BatteryState.Locked;
        } else if (_isTimeLimitedOverDischarge() || _isCutOffOverDischarge()) {
          if (_abnormalStateTracker.overDischargeTimer != null &&
                  !_abnormalStateTracker.overDischargeTimer.isActive ||
              _abnormalStateTracker.overDischargeTimer == null) {
            _abnormalStateTracker.overDischargeTimeLimited?.cancel();
            _abnormalStateTracker.seconds = 11;
            _abnormalStateTracker.overDischargeTimer =
                Timer.periodic(Duration(seconds: 1), (_) {
              _abnormalStateTracker.seconds--;
              this
                  ._abnormalStateTracker
                  .timerRx
                  .addEvent(_abnormalStateTracker.seconds);
              if (_abnormalStateTracker.seconds == 0) {
                _abnormalStateTracker.overDischargeTimer.cancel();
                Future.delayed(Duration(milliseconds: 500),
                    () => _abnormalStateTracker.timerRx.addEvent(-1));
              }
            });
          }
          battState = BatteryState.OverCurrent;
        } else {
          if (_abnormalStateTracker.overDischargeTimer != null &&
              _abnormalStateTracker.overDischargeTimer.isActive) {
            battState = BatteryState.OverCurrent;
          } else {
            battState = BatteryState.LowBatt;
          }
        }
        break;
      case '8':
        if (_abnormalStateTracker.wasSC) _abnormalStateTracker.scCounter = 0;
        if (_isOverCharge()) {
          if (_abnormalStateTracker.overChargeTimer != null &&
                  !_abnormalStateTracker.overChargeTimer.isActive ||
              _abnormalStateTracker.overChargeTimer == null) {
            _abnormalStateTracker.seconds = 11;
            _abnormalStateTracker.overChargeTimer =
                Timer.periodic(Duration(seconds: 1), (_) {
                  _abnormalStateTracker.seconds--;
                  this
                      ._abnormalStateTracker
                      .timerRx
                      .addEvent(_abnormalStateTracker.seconds);
                  if (_abnormalStateTracker.seconds == 0) {
                    _abnormalStateTracker.overChargeTimer.cancel();
                    Future.delayed(Duration(milliseconds: 400),
                            () => _abnormalStateTracker.timerRx.addEvent(-1));
                  }
                });
          }
          battState = BatteryState.OverCharge;
        } else {
          if (_abnormalStateTracker.overChargeTimer != null &&
              _abnormalStateTracker.overChargeTimer.isActive) {
            battState = BatteryState.OverCharge;
          } else {
            battState = BatteryState.EndOfCharge;
          }
        }
        break;
      case 'A':
        if (_abnormalStateTracker.wasSC) _abnormalStateTracker.scCounter = 0;
        battState = BatteryState.LowTemp;
        break;
      case 'E':
        if (_abnormalStateTracker.wasSC) _abnormalStateTracker.scCounter = 0;
        battState = BatteryState.HighTemp;
        break;
      case 'C':
        if (_abnormalStateTracker.wasSC) _abnormalStateTracker.scCounter = 0;
        battState = BatteryState.Error2;
        break;
      case '2':
        _abnormalStateTracker.scCounter++;
        if (_abnormalStateTracker.scCounter > 2) {
          battState = BatteryState.Error3;
        } else
          battState = BatteryState.Unknown;
        break;
      default:
        battState = BatteryState.Unknown;
        break;
    }
    _abnormalStateTracker.current = model.current;
    return StatusState(battState, model);
  }

  bool _isTimeLimitedOverDischarge() {
    double param = currentParams.maxTimeLimitedDischargeCurrent;
    print('DISCHARGE TIME LIMITED PARAM IS $param');
    return _abnormalStateTracker.current < 0 &&
        _abnormalStateTracker.current <= -param;
  }

  bool _isCutOffOverDischarge() {
    double param = currentParams.maxCutoffDischargeCurrent;
    print('DISCHARGE TIME LIMITED PARAM IS $param');
    return _abnormalStateTracker.current < 0 &&
        _abnormalStateTracker.current <= -param;
  }

  bool _isOverCharge() {
    double param = currentParams.maxCutoffChargeCurrent;
    print('CHARGE PARAM IS $param');
    return _abnormalStateTracker.current > 0 &&
        _abnormalStateTracker.current >=
            param; // should keep it 10 seconds again. It goes to over voltage because it's still an 8 and the current is 0 at that point
  }

  bool _isDataEmpty(String rawData) => rawData.length <= 3;

  T generateModel(String rawData);
}

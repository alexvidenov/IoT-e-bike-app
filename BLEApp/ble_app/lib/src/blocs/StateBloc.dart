import 'dart:async';

import 'package:ble_app/src/blocs/DataCachingManager.dart';
import 'package:ble_app/src/blocs/stateTracker.dart';
import 'package:ble_app/src/blocs/OutputControlBloc.dart';
import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';

abstract class StateBloc<T extends BaseModel>
    extends ParameterAwareBloc<StatusState<T>, String> with DataCachingManager {
  final _controlBloc = $<OutputControlBloc>();
  final _stateTracker = $<StateTracker>();

  RxObject<int> get overCurrentTimer => _stateTracker.timerRx;

  RxObject<ServiceNotification> get serviceRx => _stateTracker.serviceRx;

  StatusState<T> generateState(String rawData) {
    final String status = '${rawData[0]}';
    // TODO: fix the holy shit repetition going on here
    if (_isDataEmpty(rawData)) {
      if (_stateTracker.lastServiceState == ServiceState.SC ||
          _stateTracker.lastServiceState == ServiceState.ULV) {
        _stateTracker.lastServiceState = ServiceState.Undetermined;
        _stateTracker.serviceRx
            .addEvent(ServiceNotification(isStateGone: true)); // removes dialog
      } else if (_stateTracker.lastState == BatteryState.ErrorCommunication &&
          _stateTracker.lastServiceState != ServiceState.LossComm) {
        _stateTracker.lastServiceState = ServiceState.LossComm;
        _stateTracker.serviceRx.addEvent(ServiceNotification(
            state: BatteryState.ErrorCommunication, isStateGone: false));
      }
      _stateTracker.lastState = BatteryState.ErrorCommunication;
      return Status(BatteryState.ErrorCommunication);
    }

    final model = generateModel(rawData);
    BatteryState battState;
    switch (status) {
      case '0':
        if (_stateTracker.lastServiceState != ServiceState.Undetermined) {
          _stateTracker.lastServiceState = ServiceState.Undetermined;
          _stateTracker.serviceRx
              .addEvent(ServiceNotification(isStateGone: true));
        }
        if (_isTimeLimitedOverDischarge()) {
          if (_stateTracker.overDischargeTimeLimited != null &&
                  !_stateTracker.overDischargeTimeLimited.isActive ||
              _stateTracker.overDischargeTimeLimited == null) {
            _stateTracker.seconds = 11;
            _stateTracker.overDischargeTimeLimited =
                Timer.periodic(const Duration(seconds: 1), (_) {
              _stateTracker.seconds--;
              this._stateTracker.timerRx.addEvent(_stateTracker.seconds);
              if (_stateTracker.seconds == 0) {
                _stateTracker.overDischargeTimeLimited.cancel();
                Future.delayed(Duration(milliseconds: 400),
                    () => _stateTracker.timerRx.addEvent(-1));
              }
            });
          }
          battState = BatteryState.MaxPower;
        } else {
          if (_stateTracker.overDischargeTimeLimited != null &&
              _stateTracker.overDischargeTimeLimited.isActive) {
            _stateTracker.seconds = 0;
            this._stateTracker.timerRx.addEvent(_stateTracker.seconds);
            _stateTracker.overDischargeTimeLimited.cancel();
            Future.delayed(Duration(milliseconds: 400),
                () => _stateTracker.timerRx.addEvent(-1));
          } else
            battState = BatteryState.Normal;
        }
        break;
      case '4':
        if (_stateTracker.lastServiceState != ServiceState.Undetermined) {
          _stateTracker.lastServiceState = ServiceState.Undetermined;
          _stateTracker.serviceRx
              .addEvent(ServiceNotification(isStateGone: true));
        }
        if (_controlBloc.isDeviceManuallyLocked()) {
          battState = BatteryState.Locked;
        } else if (_isTimeLimitedOverDischarge() || _isCutOffOverDischarge()) {
          if (_stateTracker.overDischargeTimer != null &&
                  !_stateTracker.overDischargeTimer.isActive ||
              _stateTracker.overDischargeTimer == null) {
            _stateTracker.overDischargeTimeLimited?.cancel();
            _stateTracker.seconds = 11;
            _stateTracker.overDischargeTimer =
                Timer.periodic(Duration(seconds: 1), (_) {
              _stateTracker.seconds--;
              this._stateTracker.timerRx.addEvent(_stateTracker.seconds);
              if (_stateTracker.seconds == 0) {
                _stateTracker.overDischargeTimer.cancel();
                Future.delayed(Duration(milliseconds: 500),
                    () => _stateTracker.timerRx.addEvent(-1));
              }
            });
          }
          battState = BatteryState.OverCurrent;
        } else {
          if (_stateTracker.overDischargeTimer != null &&
              _stateTracker.overDischargeTimer.isActive) {
            battState = BatteryState.OverCurrent;
          } else {
            battState = BatteryState.LowBatt;
          }
        }
        break;
      case '8':
        if (_stateTracker.lastServiceState != ServiceState.Undetermined) {
          _stateTracker.lastServiceState = ServiceState.Undetermined;
          _stateTracker.serviceRx
              .addEvent(ServiceNotification(isStateGone: true));
        }
        if (_isOverCharge()) {
          if (_stateTracker.overChargeTimer != null &&
                  !_stateTracker.overChargeTimer.isActive ||
              _stateTracker.overChargeTimer == null) {
            _stateTracker.seconds = 11;
            _stateTracker.overChargeTimer =
                Timer.periodic(Duration(seconds: 1), (_) {
              _stateTracker.seconds--;
              this._stateTracker.timerRx.addEvent(_stateTracker.seconds);
              if (_stateTracker.seconds == 0) {
                _stateTracker.overChargeTimer.cancel();
                Future.delayed(Duration(milliseconds: 400),
                    () => _stateTracker.timerRx.addEvent(-1));
              }
            });
          }
          battState = BatteryState.OverCharge;
        } else {
          if (_stateTracker.overChargeTimer != null &&
              _stateTracker.overChargeTimer.isActive) {
            battState = BatteryState.OverCharge;
          } else {
            battState = BatteryState.EndOfCharge;
          }
        }
        break;
      case 'A':
        if (_stateTracker.lastServiceState != ServiceState.Undetermined) {
          _stateTracker.lastServiceState = ServiceState.Undetermined;
          _stateTracker.serviceRx
              .addEvent(ServiceNotification(isStateGone: true));
        }
        battState = BatteryState.LowTemp;
        break;
      case 'E':
        if (_stateTracker.lastServiceState != ServiceState.Undetermined) {
          _stateTracker.lastServiceState = ServiceState.Undetermined;
          _stateTracker.serviceRx
              .addEvent(ServiceNotification(isStateGone: true));
        }
        battState = BatteryState.HighTemp;
        break;
      case 'C':
        if (_stateTracker.lastServiceState == ServiceState.LossComm ||
            _stateTracker.lastServiceState == ServiceState.SC) {
          _stateTracker.lastServiceState = ServiceState.Undetermined;
          _stateTracker.serviceRx.addEvent(
              ServiceNotification(isStateGone: true)); // removes dialog
        } else if (_stateTracker.lastState == BatteryState.UltraLowVoltage &&
            _stateTracker.lastServiceState != ServiceState.ULV) {
          _stateTracker.lastServiceState = ServiceState.ULV;
          _stateTracker.serviceRx.addEvent(ServiceNotification(
              state: BatteryState.UltraLowVoltage, isStateGone: false));
        }
        battState = BatteryState.UltraLowVoltage;
        break;
      case '2':
        if (_stateTracker.lastServiceState == ServiceState.LossComm ||
            _stateTracker.lastServiceState == ServiceState.ULV) {
          _stateTracker.lastServiceState = ServiceState.Undetermined;
          _stateTracker.serviceRx.addEvent(
              ServiceNotification(isStateGone: true)); // removes dialog
        } else if (_stateTracker.lastState == BatteryState.ShortCircuit &&
            _stateTracker.lastServiceState != ServiceState.SC) {
          _stateTracker.lastServiceState = ServiceState.SC;
          _stateTracker.serviceRx.addEvent(ServiceNotification(
              state: BatteryState.ShortCircuit, isStateGone: false));
        }
        battState = BatteryState.ShortCircuit;
        break;
      default:
        battState = BatteryState.Unknown;
        break;
    }
    _stateTracker.current = model.current;
    _stateTracker.lastState = battState;
    return StatusState(battState, model);
  }

  bool _isTimeLimitedOverDischarge() {
    double param = currentParams.maxTimeLimitedDischargeCurrent;
    print('DISCHARGE TIME LIMITED PARAM IS $param');
    return _stateTracker.current < 0 && _stateTracker.current <= -param;
  }

  bool _isCutOffOverDischarge() {
    double param = currentParams.maxCutoffDischargeCurrent;
    print('DISCHARGE TIME LIMITED PARAM IS $param');
    return _stateTracker.current < 0 && _stateTracker.current <= -param;
  }

  bool _isOverCharge() {
    double param = currentParams.maxCutoffChargeCurrent;
    print('CHARGE PARAM IS $param');
    return _stateTracker.current > 0 && _stateTracker.current >= param;
  }

  bool _isDataEmpty(String rawData) => rawData.length <= 3;

  T generateModel(String rawData);
}

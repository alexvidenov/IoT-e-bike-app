import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';

import 'RxObject.dart';

enum ServiceState { LossComm, SC, ULV, Undetermined }

@singleton
class StateTracker {
  final timerRx = RxObject<int>();

  final serviceRx = RxObject<ServiceNotification>();

  BatteryState lastState;

  double current = 0;

  ServiceState lastServiceState = ServiceState.Undetermined;

  int seconds;
  Timer overChargeTimer;
  Timer overDischargeTimeLimited;
  Timer overDischargeTimer;
}

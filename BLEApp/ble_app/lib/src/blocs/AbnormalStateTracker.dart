import 'package:injectable/injectable.dart';
import 'dart:async';

import 'RxObject.dart';

@singleton
class AbnormalStateTracker {
  final timerRx = RxObject<int>();

  int scCounter = 0;

  bool get wasSC => scCounter >= 2;

  double current = 0;

  int seconds;

  Timer overChargeTimer;
  Timer overDischargeTimeLimited;
  Timer overDischargeTimer;
}

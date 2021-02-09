import 'package:injectable/injectable.dart';
import 'dart:async';

@singleton
class OverCurrentTimers {
  double current = 0;
  Timer overChargeTimer;
  Timer overDischargeTimeLimited;
  Timer overDischargeTimer;
}

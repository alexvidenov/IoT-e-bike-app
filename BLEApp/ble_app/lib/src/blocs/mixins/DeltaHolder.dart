import '../RxObject.dart';

mixin DeltaCalculation {
  final delta1Holder = RxObject<double>();
  final delta2Holder = RxObject<double>();

  double delta1 = 0;
  double delta2 = 0;

  double lastDelta = 0;

  int deltaCounter = 0;
}

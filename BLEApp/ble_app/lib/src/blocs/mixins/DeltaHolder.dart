import '../base/RxObject.dart';

mixin DeltaCalculation {
  final deltaHolder = RxObject<double>();
  final deltaMaxHolder = RxObject<double>();

  double tempDelta = 0;
  double maxDelta = 0;

  double lastDelta = 0;

  int deltaCounter = 0;
}

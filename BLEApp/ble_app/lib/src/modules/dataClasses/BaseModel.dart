import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';

abstract class BaseModel {
  double get totalVoltage;

  double get current;

  int get temperature;

  T generate<T extends LogModel>();
}

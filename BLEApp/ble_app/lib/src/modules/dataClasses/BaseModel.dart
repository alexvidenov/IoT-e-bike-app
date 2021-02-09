import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';

typedef GenerateModel = LogModel Function();

abstract class BaseModel {
  double get totalVoltage;

  double get current;

  int get temperature;

  LogModel generate();
}

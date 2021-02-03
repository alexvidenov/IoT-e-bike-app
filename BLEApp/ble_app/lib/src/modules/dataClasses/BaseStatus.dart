import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';

abstract class BaseStatus<T extends BaseModel> {
  T get model;

  BatteryState get state;
}

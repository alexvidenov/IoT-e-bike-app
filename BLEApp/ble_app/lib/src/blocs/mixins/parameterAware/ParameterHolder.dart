import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ParameterHolder {
  DeviceParametersModel deviceParameters;
}

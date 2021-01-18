import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';

abstract class ParameterAwareInterface {
  Stream<DeviceParametersModel> getParameters();
}

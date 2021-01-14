import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';

import 'ParameterAwareBlocInterface.dart';
import 'ParameterHolder.dart';

mixin ParameterAware implements ParameterAwareInterface {
  @override
  DeviceParametersModel getParameters() =>
      $<ParameterHolder>().deviceParameters;
}

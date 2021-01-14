import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/blocs/ParameterHolder.dart';
import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';

import 'ParameterAwareBloc.dart';

mixin ParameterAware on ParameterAwareBloc {
  @override
  DeviceParametersModel getParameters() =>
      $<ParameterHolder>().deviceParameters;
}

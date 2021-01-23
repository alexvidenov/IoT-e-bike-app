import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:flutter/cupertino.dart';

import 'ParameterAwareBlocInterface.dart';
import 'ParameterHolder.dart';

mixin ParameterAware implements ParameterAwareInterface {
  @override
  ValueNotifier<DeviceParameters> getParameters() =>
      $<ParameterHolder>().deviceParameters;
}

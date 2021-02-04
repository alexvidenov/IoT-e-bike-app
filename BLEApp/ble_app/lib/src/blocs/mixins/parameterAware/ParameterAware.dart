import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:flutter/cupertino.dart';

import 'ParameterAwareBlocInterface.dart';
import 'ParameterHolder.dart';

mixin ParameterAware implements ParameterAwareInterface {
  final _holder = $<ParameterHolder>();

  @override
  ValueNotifier<DeviceParameters> getParameters() => _holder.deviceParameters;

  @override
  DeviceParameters get currentParams => _holder.params;

  @override
  set currentParams(DeviceParameters parameters) => _holder.setParameters(parameters);
}

import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:flutter/material.dart';

abstract class ParameterAwareInterface {
  ValueNotifier<DeviceParameters> getParameters();

  DeviceParameters _params;

  DeviceParameters get currentParams => _params;

  set currentParams(DeviceParameters parameters) => _params = parameters;
}

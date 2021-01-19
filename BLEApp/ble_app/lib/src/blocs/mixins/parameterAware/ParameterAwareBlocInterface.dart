import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:flutter/material.dart';

abstract class ParameterAwareInterface {
  ValueNotifier<DeviceParametersModel> getParameters();
}

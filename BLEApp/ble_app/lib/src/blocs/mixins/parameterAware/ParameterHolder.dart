import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ParameterHolder {
  ValueNotifier<DeviceParameters> deviceParameters =
      ValueNotifier<DeviceParameters>(null);

  DeviceParameters get params => deviceParameters.value;

  void setParameters(DeviceParameters parameters) =>
      deviceParameters.value = parameters;
}

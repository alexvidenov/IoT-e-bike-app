import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';

mixin CurrentContext {
  String get curUserId => $<AuthBloc>().userId;

  String get curDeviceId => $<DeviceRepository>().deviceId;
}

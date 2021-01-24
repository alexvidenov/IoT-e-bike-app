import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'deviceConnectionState.freezed.dart';

@freezed
abstract class DeviceConnectionState with _$DeviceConnectionState {
  const factory DeviceConnectionState.normalBTState(
      {PeripheralConnectionState state}) = _NormalBTState;

  const factory DeviceConnectionState.bleException({BleError e}) =
      _BLEException;
}

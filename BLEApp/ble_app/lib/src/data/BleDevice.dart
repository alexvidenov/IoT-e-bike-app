import 'package:collection/collection.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class BleDevice {
  final Peripheral peripheral;
  final ScanResult result;

  String get id => peripheral.identifier;

  String get name =>
      peripheral.name ?? result.advertisementData.localName ?? "Unknown";

  BleDevice(ScanResult scanResult)
      : peripheral = scanResult.peripheral,
        result = scanResult;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) =>
      other is BleDevice &&
      this.name != null &&
      other.name != null &&
      compareAsciiLowerCase(this.name, other.name) == 0 &&
      this.id == other.id;

  @override
  String toString() {
    return 'BleDevice{name: $name}';
  }
}

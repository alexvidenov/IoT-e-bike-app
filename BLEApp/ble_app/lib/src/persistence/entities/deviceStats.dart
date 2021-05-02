import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'model.dart';

@Entity(tableName: "device_stats", foreignKeys: [
  ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Device,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade)
])
class DeviceStats extends Model {
  final double tripDistance;

  DeviceStats(this.tripDistance, {@required String deviceId})
      : super(id: deviceId);
}

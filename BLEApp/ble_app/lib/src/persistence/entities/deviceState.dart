import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:flutter/material.dart';
import 'package:floor/floor.dart';

import 'model.dart';

@Entity(tableName: "device_states", foreignKeys: [
  ForeignKey(
      childColumns: ['id'],
      parentColumns: ['id'],
      entity: Device,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade)
])
class DeviceState extends Model {
  @ColumnInfo(name: "is_on")
  final bool isBatteryOn;

  const DeviceState({@required String deviceNumber, this.isBatteryOn})
      : super(id: deviceNumber);
}

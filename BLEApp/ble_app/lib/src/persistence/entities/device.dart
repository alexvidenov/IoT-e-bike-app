import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'model.dart';

@Entity(
  tableName: 'devices',
)
class Device extends Model {
  @ColumnInfo(name: 'mac', nullable: true)
  final String macAddress;

  @ColumnInfo(name: 'device_name', nullable: false)
  final String name;

  @ColumnInfo(nullable: false)
  final bool isSuper;

  @ColumnInfo(name: 'changed_parameters', nullable: true)
  final String parametersToChange; // changed via FCM

  const Device(
    String id,
    this.name,
    this.isSuper, {
    this.parametersToChange,
    this.macAddress,
  }) : super(id: id);
}

import 'package:ble_app/src/persistence/entities/user.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'model.dart';

@Entity(
  tableName: 'devices',
  foreignKeys: [
    ForeignKey(
        childColumns: ['user_id'],
        parentColumns: ['id'],
        entity: User,
        onUpdate: ForeignKeyAction.cascade,
        onDelete: ForeignKeyAction.cascade)
  ],
)
class Device extends Model {
  @ColumnInfo(name: 'user_id', nullable: false)
  final String userId;

  final String macAddress;

  String name;

  @ColumnInfo(nullable: true)
  String parametersToChange; // changed via FCM

  Device(
      {@required String deviceId,
      @required this.userId,
      this.macAddress,
      this.name})
      : super(id: deviceId);
}

import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/user.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'users_devices', primaryKeys: [
  'user_id',
  'device_id'
], foreignKeys: [
  ForeignKey(
      childColumns: ['user_id'],
      parentColumns: ['id'],
      entity: User,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade),
  ForeignKey(
      childColumns: ['device_id'],
      parentColumns: ['id'],
      entity: Device,
      onUpdate: ForeignKeyAction.cascade,
      onDelete: ForeignKeyAction.cascade)
])
class UserDevices {
  @ColumnInfo(name: 'user_id', nullable: false)
  final String userId;
  @ColumnInfo(name: 'device_id', nullable: false)
  final String deviceId;

  const UserDevices(this.userId, this.deviceId);
}

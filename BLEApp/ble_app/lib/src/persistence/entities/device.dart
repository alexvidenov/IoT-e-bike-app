import 'package:ble_app/src/persistence/entities/user.dart';
import 'package:floor/floor.dart';

import 'model.dart';

@Entity(
  tableName: 'devices',
  foreignKeys: [
    ForeignKey(
      childColumns: ['user_id'],
      parentColumns: ['id'],
      entity: User,
    )
  ],
)
class Device extends Model {
  @ColumnInfo(name: 'user_id', nullable: false)
  final String userId; // TODO: actually make it int here as well

  final String macAddress;

  String name;

  @ColumnInfo(nullable: true)
  String parametersToChange; // changed via FCM

  Device({int deviceId, this.userId, this.macAddress, this.name})
      : super(id: deviceId);
}

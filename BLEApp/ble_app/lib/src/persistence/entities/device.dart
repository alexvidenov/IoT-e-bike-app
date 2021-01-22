import 'package:ble_app/src/persistence/entities/user.dart';
import 'package:floor/floor.dart';

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
class Device {
  @PrimaryKey()
  final String deviceId;

  @ColumnInfo(name: 'user_id', nullable: false)
  // include foreign key to that
  final String userId;

  // these will be changed via FCM
  final String
      parametersToChange; // toJson and fromJson required from the calling object

  Device(this.deviceId, this.userId, this.parametersToChange);
}

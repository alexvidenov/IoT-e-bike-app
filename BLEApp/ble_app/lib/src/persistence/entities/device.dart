import 'package:floor/floor.dart';

@Entity(tableName: 'devices')
class Device {
  @PrimaryKey()
  final String deviceId;

  final String userId;

  const Device(this.deviceId, this.userId);
}

import 'package:floor/floor.dart';

@Entity(tableName: 'devices')
class Device {
  @PrimaryKey()
  final String deviceId;

  // include foreign key to that
  final String userId;

  // these will be changed via FCM
  final String
      parametersToChange; // toJson and fromJson required from the calling object

  Device(this.deviceId, this.userId, this.parametersToChange);
}

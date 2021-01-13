import 'package:floor/floor.dart';

@Entity(tableName: 'devices')
class Device {
  @PrimaryKey()
  final String deviceId;

  final String userId;

  String
      deviceParametersModel; // toJson and fromJson required from the calling object

  Device(this.deviceId, this.userId);
}

import 'package:floor/floor.dart';

@Entity(tableName: 'devices')
class Device {
  @PrimaryKey()
  final String serialNumber; // serial

  final String userId; // the device user

  const Device(this.serialNumber, this.userId);
}

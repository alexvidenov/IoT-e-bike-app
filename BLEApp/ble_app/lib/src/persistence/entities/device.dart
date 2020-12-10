import 'package:floor/floor.dart';

@Entity(tableName: 'devices')
class Device {
  @PrimaryKey()
  final String id;

  const Device(this.id);
}

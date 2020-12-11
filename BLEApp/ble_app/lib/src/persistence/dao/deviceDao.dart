import 'package:ble_app/src/persistence/dao/dao.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:floor/floor.dart';

@dao
abstract class DeviceDao extends Dao<Device> {
  @Query('SELECT * FROM devices')
  Future<List<Device>> fetchDevices();

  @Query(
      'SELECT * FROM devices WHERE serialNumber = :serialNumber AND userId = :userId')
  Future<Device> fetchDevice(String serialNumber, String userId);
}

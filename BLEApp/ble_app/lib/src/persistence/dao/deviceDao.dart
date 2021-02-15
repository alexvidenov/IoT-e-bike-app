import 'package:ble_app/src/persistence/dao/dao.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:floor/floor.dart';

@dao
abstract class DeviceDao extends Dao<Device> {
  @Query('''SELECT *
            FROM devices d
            INNER JOIN users_devices u ON u.user_id = :userId
            GROUP BY d.id
         ''')
  Future<List<Device>> fetchDevices(String userId);

  @Query('''SELECT *
            FROM devices d
            INNER JOIN users_devices u ON u.user_id = :userId AND d.id = :deviceId
            GROUP BY d.id
         ''')
  Future<Device> fetchUserDevice(
      String deviceId, String userId); // rename to fetch user device

  @Query('SELECT * FROM devices WHERE id = :deviceId')
  Future<Device> fetchDevice(String deviceId);

  @Query(
      'UPDATE devices SET parametersToChange = :parameters WHERE id = :deviceId')
  Future<void> updateParametersToChange(String parameters, String deviceId);

  @Query('UPDATE devices SET macAddress = :macAddress WHERE id = :deviceId')
  Future<void> setMacAddress(String macAddress, String deviceId);

  @Query('UPDATE devices SET name = :newName WHERE id = :deviceId')
  Future<void> renameDevice(String newName, String deviceId);
}

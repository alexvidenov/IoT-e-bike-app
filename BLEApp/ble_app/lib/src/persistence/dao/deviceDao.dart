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
  Future<List<Device>> fetchUserDevices(String userId);

  @Query('''DELETE FROM devices 
            WHERE id IN (
              SELECT id
              FROM devices d
              INNER JOIN users_devices u ON u.user_id = :userId
            )
         ''')
  Future<void> deleteUserDevices(String userId);

  @Query('''SELECT *
            FROM devices d
            INNER JOIN users_devices u ON u.user_id = :userId AND d.id = :deviceId
            GROUP BY d.id
         ''')
  Future<Device> fetchUserDevice(String deviceId, String userId);

  @Query('SELECT * FROM devices WHERE id = :deviceId')
  Future<Device> fetchDevice(String deviceId);

  @Query('SELECT * FROM devices WHERE id = :deviceId')
  Stream<Device> fetchDeviceAsStream(String deviceId);

  @Query('SELECT * FROM devices WHERE mac = :mac')
  Future<Device> fetchDeviceByMac(String mac);

  @Query(
      'UPDATE devices SET parametersToChange = :parameters WHERE id = :deviceId')
  Future<void> updateParametersToChange(String parameters, String deviceId);

  @Query('UPDATE devices SET device_name = :newName WHERE id = :deviceId')
  Future<void> updateDeviceName(String newName, String deviceId);

  @Query('UPDATE devices SET mac = :mac WHERE id = :deviceId')
  Future<void> setMacAddress(String macAddress, String deviceId);
}

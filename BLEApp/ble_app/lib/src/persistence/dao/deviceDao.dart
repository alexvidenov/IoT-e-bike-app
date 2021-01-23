import 'package:ble_app/src/persistence/dao/dao.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:floor/floor.dart';

@dao
abstract class DeviceDao extends Dao<Device> {
  @Query("SELECT * FROM devices WHERE user_id = :userId")
  Future<List<Device>> fetchDevices(String userId);

  @Query('SELECT * FROM devices WHERE id = :deviceId AND user_id = :userId')
  Future<Device> fetchDevice(String deviceId, String userId);

  @Query(
      'UPDATE devices SET parametersToChange = :parameters WHERE id = :deviceId')
  Future<void> updateParametersToChange(String parameters, String deviceId);

  @Query('UPDATE devices SET macAddress = :macAddress WHERE id = :deviceId')
  Future<void> setMacAddress(String macAddress, int deviceId);
}

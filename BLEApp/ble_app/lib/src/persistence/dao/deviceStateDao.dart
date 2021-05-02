import 'package:ble_app/src/persistence/dao/dao.dart';
import 'package:ble_app/src/persistence/entities/deviceState.dart';
import 'package:floor/floor.dart';

@dao
abstract class DeviceStateDao extends Dao<DeviceState> {
  @Query('SELECT * FROM device_states WHERE id = :deviceId')
  Future<DeviceState> fetchDeviceState(String deviceId);

  @Query('UPDATE device_states SET is_on = :isOn WHERE id = :deviceId')
  Future<void> updateDeviceState(String deviceId, bool isOn);
}

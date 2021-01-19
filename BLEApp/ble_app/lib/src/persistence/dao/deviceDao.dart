import 'package:ble_app/src/persistence/dao/dao.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:floor/floor.dart';

//@TypeConverters(value)
@dao
abstract class DeviceDao extends Dao<Device> {
  @Query("SELECT * FROM devices")
  Future<List<Device>> fetchDevices();

  @Query(
      'SELECT * FROM devices WHERE deviceId = :deviceId AND userId = :userId')
  Future<Device> fetchDevice(String deviceId, String userId);

  @Query(
      'UPDATE devices SET parametersToChange = :parameters WHERE deviceId = :deviceId')
  Future<void> updateParametersToChange(String parameters, String deviceId);

  //@Query('SELECT parametersToChange FROM devices WHERE deviceId = :deviceId')
  //Future<String> fetchDeviceParametersToChange(String deviceId);

/*
  @Query(
    'SELECT parametersToChange FROM devices WHERE deviceId = :deviceId') // TODO look up type converters
  Future<String> fetchDeviceParametersToChange(String deviceId);

  @Query(
      'INSERT INTO devices(parametersToChange) WHERE deviceId = :deviceID VALUES (:parameters)')
  Future<void> insertDeviceParametersToChange(
      String deviceId, String parameters);
   */
}

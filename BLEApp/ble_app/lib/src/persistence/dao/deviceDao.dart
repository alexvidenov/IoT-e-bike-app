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

  //@Query('SELECT deviceParametersModel FROM devices WHERE deviceId = :deviceId') // TODO look up type converters
  //Stream<String> deviceParametersAsStream(String deviceId);

  @Query(
      'UPDATE devices SET deviceParametersModel = :deviceParameters WHERE deviceId = :deviceId')
  Future<void> updateDeviceParameters(String deviceId, String deviceParameters);
}

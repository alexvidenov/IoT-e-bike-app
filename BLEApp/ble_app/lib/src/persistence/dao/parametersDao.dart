import 'package:ble_app/src/persistence/dao/dao.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:floor/floor.dart';

@dao
abstract class ParametersDao extends Dao<DeviceParameters> {
  @Query('SELECT * FROM parameters WHERE id = :deviceId')
  Stream<DeviceParameters> fetchDeviceParametersAsStream(String deviceId);

  @Query('SELECT * FROM parameters WHERE id = :deviceId')
  Future<DeviceParameters> fetchDeviceParametersAsFuture(String deviceId);
}

import 'package:ble_app/src/persistence/entities/userDevices.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDevicesDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertEntity(UserDevices entity);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertList(List<UserDevices> entities);
}

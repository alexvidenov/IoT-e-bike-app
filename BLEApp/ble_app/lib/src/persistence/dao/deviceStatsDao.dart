import 'package:ble_app/src/persistence/dao/dao.dart';
import 'package:ble_app/src/persistence/entities/deviceState.dart';
import 'package:ble_app/src/persistence/entities/deviceStats.dart';
import 'package:floor/floor.dart';

@dao
abstract class DeviceStateDao extends Dao<DeviceStats> {}

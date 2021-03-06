import 'package:ble_app/src/persistence/dao/deviceDao.dart';
import 'package:ble_app/src/persistence/dao/parametersDao.dart';
import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/entities/deviceState.dart';
import 'package:ble_app/src/persistence/entities/userDevices.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/persistence/entities/user.dart';
import 'package:floor/floor.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dart:async';

import 'dao/deviceStateDao.dart';
import 'dao/userDevicesDao.dart';

part 'localDatabase.g.dart';

@Database(
    version: 6,
    entities: [User, Device, DeviceParameters, UserDevices, DeviceState])
@singleton
abstract class LocalDatabase extends FloorDatabase {
  UserDao get userDao;

  DeviceDao get deviceDao;

  ParametersDao get parametersDao;

  UserDevicesDao get userDevicesDao;

  DeviceStateDao get deviceStateDao;

  static final Migration migration2to3 = Migration(2, 3, (_) async => {});

  static final Migration migration3to4 = Migration(3, 4, (_) async => {});

  static final Migration migration4to5 = Migration(3, 4, (_) async => {});

  static final Migration migration5to6 = Migration(5, 6, (_) async => {});

  @preResolve
  @factoryMethod
  static Future<LocalDatabase> getInstance() async => await $FloorLocalDatabase
      .databaseBuilder('ble_app_local_database.db')
      .addMigrations([migration2to3, migration3to4, migration4to5, migration5to6]).build();
}

import 'package:ble_app/src/persistence/dao/deviceDao.dart';
import 'package:ble_app/src/persistence/dao/parametersDao.dart';
import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/persistence/entities/user.dart';
import 'package:floor/floor.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dart:async';

part 'localDatabase.g.dart';

@Database(version: 2, entities: [User, Device, DeviceParameters])
@singleton
abstract class LocalDatabase extends FloorDatabase {
  UserDao get userDao;

  DeviceDao get deviceDao;

  ParametersDao get parametersDao;

  @preResolve
  @factoryMethod
  static Future<LocalDatabase> getInstance() async => await $FloorLocalDatabase
      .databaseBuilder('ble_app_local_database.db')
      .build();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorLocalDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$LocalDatabaseBuilder databaseBuilder(String name) =>
      _$LocalDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$LocalDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$LocalDatabaseBuilder(null);
}

class _$LocalDatabaseBuilder {
  _$LocalDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$LocalDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$LocalDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<LocalDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$LocalDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$LocalDatabase extends LocalDatabase {
  _$LocalDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao _userDaoInstance;

  DeviceDao _deviceDaoInstance;

  ParametersDao _parametersDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 4,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`email` TEXT, `password` TEXT, `id` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `devices` (`user_id` TEXT NOT NULL, `macAddress` TEXT, `name` TEXT, `parametersToChange` TEXT, `id` TEXT, FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `parameters` (`cellCount` INTEGER, `maxCellVoltage` REAL, `maxRecoveryVoltage` REAL, `balanceCellVoltage` REAL, `minCellVoltage` REAL, `minCellRecoveryVoltage` REAL, `ultraLowCellVoltage` REAL, `maxTimeLimitedDischargeCurrent` REAL, `maxCutoffDischargeCurrent` REAL, `maxCurrentTimeLimitPeriod` INTEGER, `maxCutoffChargeCurrent` REAL, `motoHoursCounterCurrentThreshold` INTEGER, `currentCutOffTimerPeriod` INTEGER, `maxCutoffTemperature` INTEGER, `maxTemperatureRecovery` INTEGER, `minTemperatureRecovery` INTEGER, `minCutoffTemperature` INTEGER, `motoHoursChargeCounter` INTEGER, `motoHoursDischargeCounter` INTEGER, `id` TEXT, FOREIGN KEY (`id`) REFERENCES `devices` (`id`) ON UPDATE CASCADE ON DELETE CASCADE, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  DeviceDao get deviceDao {
    return _deviceDaoInstance ??= _$DeviceDao(database, changeListener);
  }

  @override
  ParametersDao get parametersDao {
    return _parametersDaoInstance ??= _$ParametersDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, dynamic>{
                  'email': item.email,
                  'password': item.password,
                  'id': item.id
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, dynamic>{
                  'email': item.email,
                  'password': item.password,
                  'id': item.id
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, dynamic>{
                  'email': item.email,
                  'password': item.password,
                  'id': item.id
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> fetchUsers() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, dynamic> row) => User(row['id'] as String,
            row['email'] as String, row['password'] as String));
  }

  @override
  Future<User> fetchUser(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?',
        arguments: <dynamic>[email],
        mapper: (Map<String, dynamic> row) => User(row['id'] as String,
            row['email'] as String, row['password'] as String));
  }

  @override
  Future<void> deleteUser(String email) async {
    await _queryAdapter.queryNoReturn('DELETE FROM users WHERE email = ?',
        arguments: <dynamic>[email]);
  }

  @override
  Future<void> insertEntity(User entity) async {
    await _userInsertionAdapter.insert(entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertList(List<User> entities) async {
    await _userInsertionAdapter.insertList(
        entities, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateEntity(User entity) async {
    await _userUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(User entity) async {
    await _userDeletionAdapter.delete(entity);
  }
}

class _$DeviceDao extends DeviceDao {
  _$DeviceDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _deviceInsertionAdapter = InsertionAdapter(
            database,
            'devices',
            (Device item) => <String, dynamic>{
                  'user_id': item.userId,
                  'macAddress': item.macAddress,
                  'name': item.name,
                  'parametersToChange': item.parametersToChange,
                  'id': item.id
                }),
        _deviceUpdateAdapter = UpdateAdapter(
            database,
            'devices',
            ['id'],
            (Device item) => <String, dynamic>{
                  'user_id': item.userId,
                  'macAddress': item.macAddress,
                  'name': item.name,
                  'parametersToChange': item.parametersToChange,
                  'id': item.id
                }),
        _deviceDeletionAdapter = DeletionAdapter(
            database,
            'devices',
            ['id'],
            (Device item) => <String, dynamic>{
                  'user_id': item.userId,
                  'macAddress': item.macAddress,
                  'name': item.name,
                  'parametersToChange': item.parametersToChange,
                  'id': item.id
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Device> _deviceInsertionAdapter;

  final UpdateAdapter<Device> _deviceUpdateAdapter;

  final DeletionAdapter<Device> _deviceDeletionAdapter;

  @override
  Future<List<Device>> fetchDevices(String userId) async {
    return _queryAdapter.queryList('SELECT * FROM devices WHERE user_id = ?',
        arguments: <dynamic>[userId],
        mapper: (Map<String, dynamic> row) => Device(
            userId: row['user_id'] as String,
            parametersToChange: row['parametersToChange'] as String,
            macAddress: row['macAddress'] as String,
            name: row['name'] as String));
  }

  @override
  Future<Device> fetchDevice(String deviceId, String userId) async {
    return _queryAdapter.query(
        'SELECT * FROM devices WHERE id = ? AND user_id = ?',
        arguments: <dynamic>[deviceId, userId],
        mapper: (Map<String, dynamic> row) => Device(
            userId: row['user_id'] as String,
            parametersToChange: row['parametersToChange'] as String,
            macAddress: row['macAddress'] as String,
            name: row['name'] as String));
  }

  @override
  Future<void> updateParametersToChange(
      String parameters, String deviceId) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE devices SET parametersToChange = ? WHERE id = ?',
        arguments: <dynamic>[parameters, deviceId]);
  }

  @override
  Future<void> setMacAddress(String macAddress, String deviceId) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE devices SET macAddress = ? WHERE id = ?',
        arguments: <dynamic>[macAddress, deviceId]);
  }

  @override
  Future<void> renameDevice(String newName, String deviceId) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE devices SET name = ? WHERE id = ?',
        arguments: <dynamic>[newName, deviceId]);
  }

  @override
  Future<void> insertEntity(Device entity) async {
    await _deviceInsertionAdapter.insert(entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertList(List<Device> entities) async {
    await _deviceInsertionAdapter.insertList(
        entities, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateEntity(Device entity) async {
    await _deviceUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(Device entity) async {
    await _deviceDeletionAdapter.delete(entity);
  }
}

class _$ParametersDao extends ParametersDao {
  _$ParametersDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _deviceParametersInsertionAdapter = InsertionAdapter(
            database,
            'parameters',
            (DeviceParameters item) => <String, dynamic>{
                  'cellCount': item.cellCount,
                  'maxCellVoltage': item.maxCellVoltage,
                  'maxRecoveryVoltage': item.maxRecoveryVoltage,
                  'balanceCellVoltage': item.balanceCellVoltage,
                  'minCellVoltage': item.minCellVoltage,
                  'minCellRecoveryVoltage': item.minCellRecoveryVoltage,
                  'ultraLowCellVoltage': item.ultraLowCellVoltage,
                  'maxTimeLimitedDischargeCurrent':
                      item.maxTimeLimitedDischargeCurrent,
                  'maxCutoffDischargeCurrent': item.maxCutoffDischargeCurrent,
                  'maxCurrentTimeLimitPeriod': item.maxCurrentTimeLimitPeriod,
                  'maxCutoffChargeCurrent': item.maxCutoffChargeCurrent,
                  'motoHoursCounterCurrentThreshold':
                      item.motoHoursCounterCurrentThreshold,
                  'currentCutOffTimerPeriod': item.currentCutOffTimerPeriod,
                  'maxCutoffTemperature': item.maxCutoffTemperature,
                  'maxTemperatureRecovery': item.maxTemperatureRecovery,
                  'minTemperatureRecovery': item.minTemperatureRecovery,
                  'minCutoffTemperature': item.minCutoffTemperature,
                  'motoHoursChargeCounter': item.motoHoursChargeCounter,
                  'motoHoursDischargeCounter': item.motoHoursDischargeCounter,
                  'id': item.id
                },
            changeListener),
        _deviceParametersUpdateAdapter = UpdateAdapter(
            database,
            'parameters',
            ['id'],
            (DeviceParameters item) => <String, dynamic>{
                  'cellCount': item.cellCount,
                  'maxCellVoltage': item.maxCellVoltage,
                  'maxRecoveryVoltage': item.maxRecoveryVoltage,
                  'balanceCellVoltage': item.balanceCellVoltage,
                  'minCellVoltage': item.minCellVoltage,
                  'minCellRecoveryVoltage': item.minCellRecoveryVoltage,
                  'ultraLowCellVoltage': item.ultraLowCellVoltage,
                  'maxTimeLimitedDischargeCurrent':
                      item.maxTimeLimitedDischargeCurrent,
                  'maxCutoffDischargeCurrent': item.maxCutoffDischargeCurrent,
                  'maxCurrentTimeLimitPeriod': item.maxCurrentTimeLimitPeriod,
                  'maxCutoffChargeCurrent': item.maxCutoffChargeCurrent,
                  'motoHoursCounterCurrentThreshold':
                      item.motoHoursCounterCurrentThreshold,
                  'currentCutOffTimerPeriod': item.currentCutOffTimerPeriod,
                  'maxCutoffTemperature': item.maxCutoffTemperature,
                  'maxTemperatureRecovery': item.maxTemperatureRecovery,
                  'minTemperatureRecovery': item.minTemperatureRecovery,
                  'minCutoffTemperature': item.minCutoffTemperature,
                  'motoHoursChargeCounter': item.motoHoursChargeCounter,
                  'motoHoursDischargeCounter': item.motoHoursDischargeCounter,
                  'id': item.id
                },
            changeListener),
        _deviceParametersDeletionAdapter = DeletionAdapter(
            database,
            'parameters',
            ['id'],
            (DeviceParameters item) => <String, dynamic>{
                  'cellCount': item.cellCount,
                  'maxCellVoltage': item.maxCellVoltage,
                  'maxRecoveryVoltage': item.maxRecoveryVoltage,
                  'balanceCellVoltage': item.balanceCellVoltage,
                  'minCellVoltage': item.minCellVoltage,
                  'minCellRecoveryVoltage': item.minCellRecoveryVoltage,
                  'ultraLowCellVoltage': item.ultraLowCellVoltage,
                  'maxTimeLimitedDischargeCurrent':
                      item.maxTimeLimitedDischargeCurrent,
                  'maxCutoffDischargeCurrent': item.maxCutoffDischargeCurrent,
                  'maxCurrentTimeLimitPeriod': item.maxCurrentTimeLimitPeriod,
                  'maxCutoffChargeCurrent': item.maxCutoffChargeCurrent,
                  'motoHoursCounterCurrentThreshold':
                      item.motoHoursCounterCurrentThreshold,
                  'currentCutOffTimerPeriod': item.currentCutOffTimerPeriod,
                  'maxCutoffTemperature': item.maxCutoffTemperature,
                  'maxTemperatureRecovery': item.maxTemperatureRecovery,
                  'minTemperatureRecovery': item.minTemperatureRecovery,
                  'minCutoffTemperature': item.minCutoffTemperature,
                  'motoHoursChargeCounter': item.motoHoursChargeCounter,
                  'motoHoursDischargeCounter': item.motoHoursDischargeCounter,
                  'id': item.id
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DeviceParameters> _deviceParametersInsertionAdapter;

  final UpdateAdapter<DeviceParameters> _deviceParametersUpdateAdapter;

  final DeletionAdapter<DeviceParameters> _deviceParametersDeletionAdapter;

  @override
  Stream<DeviceParameters> fetchDeviceParameters(String deviceId) {
    return _queryAdapter.queryStream('SELECT * FROM parameters WHERE id = ?',
        arguments: <dynamic>[deviceId],
        queryableName: 'parameters',
        isView: false,
        mapper: (Map<String, dynamic> row) => DeviceParameters(
            id: row['id'] as String,
            cellCount: row['cellCount'] as int,
            maxCellVoltage: row['maxCellVoltage'] as double,
            maxRecoveryVoltage: row['maxRecoveryVoltage'] as double,
            balanceCellVoltage: row['balanceCellVoltage'] as double,
            minCellVoltage: row['minCellVoltage'] as double,
            minCellRecoveryVoltage: row['minCellRecoveryVoltage'] as double,
            ultraLowCellVoltage: row['ultraLowCellVoltage'] as double,
            maxTimeLimitedDischargeCurrent:
                row['maxTimeLimitedDischargeCurrent'] as double,
            maxCutoffDischargeCurrent:
                row['maxCutoffDischargeCurrent'] as double,
            maxCurrentTimeLimitPeriod: row['maxCurrentTimeLimitPeriod'] as int,
            maxCutoffChargeCurrent: row['maxCutoffChargeCurrent'] as double,
            motoHoursCounterCurrentThreshold:
                row['motoHoursCounterCurrentThreshold'] as int,
            currentCutOffTimerPeriod: row['currentCutOffTimerPeriod'] as int,
            maxCutoffTemperature: row['maxCutoffTemperature'] as int,
            maxTemperatureRecovery: row['maxTemperatureRecovery'] as int,
            minTemperatureRecovery: row['minTemperatureRecovery'] as int,
            minCutoffTemperature: row['minCutoffTemperature'] as int,
            motoHoursChargeCounter: row['motoHoursChargeCounter'] as int,
            motoHoursDischargeCounter:
                row['motoHoursDischargeCounter'] as int));
  }

  @override
  Future<void> insertEntity(DeviceParameters entity) async {
    await _deviceParametersInsertionAdapter.insert(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertList(List<DeviceParameters> entities) async {
    await _deviceParametersInsertionAdapter.insertList(
        entities, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateEntity(DeviceParameters entity) async {
    await _deviceParametersUpdateAdapter.update(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(DeviceParameters entity) async {
    await _deviceParametersDeletionAdapter.delete(entity);
  }
}

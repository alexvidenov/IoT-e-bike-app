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

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `users` (`id` TEXT, `email` TEXT, `password` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `devices` (`deviceId` TEXT, `userId` TEXT, PRIMARY KEY (`deviceId`))');

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
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'email': item.email,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

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
  Future<void> insertEntity(User entity) async {
    await _userInsertionAdapter.insert(entity, OnConflictStrategy.replace);
  }
}

class _$DeviceDao extends DeviceDao {
  _$DeviceDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _deviceInsertionAdapter = InsertionAdapter(
            database,
            'devices',
            (Device item) => <String, dynamic>{
                  'deviceId': item.deviceId,
                  'userId': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Device> _deviceInsertionAdapter;

  @override
  Future<List<Device>> fetchDevices() async {
    return _queryAdapter.queryList('SELECT * FROM devices',
        mapper: (Map<String, dynamic> row) =>
            Device(row['deviceId'] as String, row['userId'] as String));
  }

  @override
  Future<Device> fetchDevice(String deviceId, String userId) async {
    return _queryAdapter.query(
        'SELECT * FROM devices WHERE deviceId = ? AND userId = ?',
        arguments: <dynamic>[deviceId, userId],
        mapper: (Map<String, dynamic> row) =>
            Device(row['deviceId'] as String, row['userId'] as String));
  }

  @override
  Future<void> insertEntity(Device entity) async {
    await _deviceInsertionAdapter.insert(entity, OnConflictStrategy.replace);
  }
}

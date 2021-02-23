import 'package:ble_app/src/blocs/LocationCachingManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

@singleton
class SembastDatabase {
  static SembastDatabase _instance;
  static Database _routesDB;
  static Database _userDataDB;

  final _coordinatesStore = stringMapStoreFactory.store('coordinates');

  final _userDataStore = stringMapStoreFactory.store('userData');

  static Future<String> _generateDBPath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    return join(dir.path, '$filename.db');
  }

  @preResolve
  @factoryMethod
  static Future<SembastDatabase> getInstance() async {
    _instance = _instance ?? SembastDatabase();
    _userDataDB = _userDataDB ??
        await databaseFactoryIo
            .openDatabase(await _generateDBPath('sembast_user_data'));
    return _instance;
  }

  Future<void> openRoutesDB() async => _routesDB = _routesDB ??
      await databaseFactoryIo
          .openDatabase(await _generateDBPath('sembast_locations'));

  void createRouteFile(
      String userId, String deviceId, String initialTimeStamp) {
    _coordinatesStore.record(initialTimeStamp).put(_routesDB, {
      'userId': userId,
      'deviceId': deviceId,
      'startedAt': initialTimeStamp,
      'finishedAt': '',
      'name': '',
      'length': 0.0,
      'consumed': 0.0,
      'coordinates': []
    });
  }

  void updateCoordinatesRouteFile(
      String userId, String deviceId, String fileTimeStamp,
      {List<LatLng> coordinates, String finishedAt}) {
    _coordinatesStore.record(fileTimeStamp).put(
        _routesDB,
        {
          'coordinates': coordinates.map((c) => c.toJson()).toList(),
          'finishedAt': finishedAt
        },
        merge: true);
  }

  void renameRecording(
      String userId, String deviceId, String fileTimeStamp, String newName) {
    _coordinatesStore
        .record(fileTimeStamp)
        .put(_routesDB, {'name': newName}, merge: true);
  }

  Future<Stream<List<RouteFileModel>>> cachedRoutesStream(
          String userId, String deviceId) async =>
      (await _coordinatesStore.query(
              finder: Finder(
                  filter: Filter.and(
                      [Filter.equals('userId', userId), Filter.equals('deviceId', deviceId)]))))
          .onSnapshots(_routesDB)
          .map((snap) => snap
              .map((e) => RouteFileModel(
                  name: e['name'],
                  startedAt: e['startedAt'],
                  finishedAt: e['finishedAt'],
                  lengthInKilometers: e['length'],
                  wastedPowerInWh: e['consumed'],
                  coordinates: (e['coordinates'] as List<dynamic>)
                      .map((c) => LatLng.fromJson(c))
                      .toList()))
              .toList());

  void setUserLogData(String json) =>
      _userDataStore.record('userLogs').put(_userDataDB, {'userLogs': json});

  Future<String> getUserLogData() =>
      _userDataStore.record('userLogs').get(_userDataDB).then((value) {
        if (value == null)
          return null;
        else
          return value['userLogs'];
      });

  Future<void> deleteUserLogData() async =>
      await _userDataStore.record('userLogs').delete(_userDataDB);
}

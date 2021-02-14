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
  static Database _sembastDB;

  final _coordinatesStore = stringMapStoreFactory.store('coordinates');

  final _userDataStore = stringMapStoreFactory.store('userData');

  @preResolve
  @factoryMethod
  static Future<SembastDatabase> getInstance() async {
    _instance = _instance ?? SembastDatabase();
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, 'sembast_locations.db');
    _sembastDB = _sembastDB ?? await databaseFactoryIo.openDatabase(dbPath);
    return _instance;
  }

  void createRouteFile(String userId, String deviceId, String fileName) {
    _coordinatesStore.record(fileName).put(_sembastDB, {
      'userId': userId,
      'deviceId': deviceId,
      'name': fileName,
      'coordinates': []
    });
  }

  void updateCoordinatesRouteFile(
      String userId, String deviceId, String fileName,
      {List<LatLng> coordinates}) {
    _coordinatesStore.record(fileName).put(_sembastDB,
        {'coordinates': coordinates.map((c) => c.toJson()).toList()},
        merge: true);
  }

  void renameRecording(
      String userId, String deviceId, String oldName, String newName) {
    _coordinatesStore
        .record(oldName)
        .put(_sembastDB, {'name': newName}, merge: true);
  }

  Future<Stream<List<RouteFileModel>>> cachedRoutesStream(
          String userId, String deviceId) async =>
      (await _coordinatesStore.query(
              finder: Finder(
                  filter: Filter.and(
                      [Filter.equals('userId', userId), Filter.equals('deviceId', deviceId)]))))
          .onSnapshots(_sembastDB)
          .map((snap) => snap
              .map((e) => RouteFileModel(
                  e['name'],
                  (e['coordinates'] as List<dynamic>)
                      .map((c) => LatLng.fromJson(c))
                      .toList()))
              .toList());

  void setUserLogData(String json) =>
      _userDataStore.record('userLogs').put(_sembastDB, {'userLogs': json});

  Future<String> getUserLogData() =>
      _userDataStore.record('userLogs').get(_sembastDB).then((value) {
        if (value == null)
          return null;
        else
          return value['userLogs'];
      });

  Future<void> deleteUserLogData() async =>
      await _userDataStore.record('userLogs').delete(_sembastDB);
}

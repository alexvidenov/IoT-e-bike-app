import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/LocationCachingManager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

@singleton
class SembastDatabase with CurrentContext {
  // FIXME: db services should not be aware of users or devices
  static SembastDatabase _instance;
  static Database _sembastDB;

  final _coordinatesStore = stringMapStoreFactory.store('coordinates');

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
    _coordinatesStore.record(fileName).add(_sembastDB, {
      'userId': userId,
      'deviceId': deviceId,
      'name': fileName,
      'coordinates': []
    });
  }

  void updateCoordinatesRouteFile(
      String userId, String deviceId, String fileName,
      {List<LatLng> coordinates}) {
    _coordinatesStore.record(fileName).update(_sembastDB,
        {'coordinates': coordinates.map((c) => c.toJson()).toList()});
  }

  void renameRecording(
      String userId, String deviceId, String oldName, String newName) {
    _coordinatesStore.record(oldName).update(_sembastDB, {'name': newName});
  }

  Future<Stream<List<RouteFileModel>>> get cachedRoutesStream async =>
      (await _coordinatesStore.query(
              finder: Finder(
                  filter: Filter.and([
        Filter.equals('userId', curUserId),
        Filter.equals('deviceId', curDeviceId)
      ]))))
          .onSnapshots(_sembastDB)
          .map((snap) => snap
              .map((e) => RouteFileModel(
                  e['name'],
                  (e['coordinates'] as List<dynamic>)
                      .map((c) => LatLng.fromJson(c))
                      .toList()))
              .toList());
}

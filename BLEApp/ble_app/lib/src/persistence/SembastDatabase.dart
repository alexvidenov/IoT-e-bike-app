import 'package:injectable/injectable.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

@singleton
class SembastDatabase {
  static SembastDatabase _instance;
  static Database _sembastDB;

  final _coordinatesStore = stringMapStoreFactory.store('coordinates');

  @preResolve
  @factoryMethod
  static Future<SembastDatabase> getInstance() async {
    _instance = _instance ?? SembastDatabase();
    _sembastDB =
        _sembastDB ?? await databaseFactoryIo.openDatabase('sembast_db.db');
    return _instance;
  }

  void cacheCoordinates(String userId, String deviceId, String routeName) {
    _coordinatesStore
        .record(routeName)
        .add(_sembastDB, {'userId': userId, 'deviceId': deviceId});
  }
}

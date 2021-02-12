import 'package:injectable/injectable.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

@singleton
class SembastDatabase {
  static SembastDatabase _instance;
  static Database _sembastDB;

  @preResolve
  @factoryMethod
  static Future<SembastDatabase> getInstance() async {
    _instance = _instance ?? SembastDatabase();
    _sembastDB =
        _sembastDB ?? await databaseFactoryIo.openDatabase('sembast_db.db');
    return _instance;
  }
}

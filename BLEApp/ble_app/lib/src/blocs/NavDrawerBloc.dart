import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:injectable/injectable.dart';

@injectable
class NavDrawerBloc with CurrentContext {
  final LocalDatabaseManager _db;

  NavDrawerBloc(this._db);

  Stream<bool> get authorizedToAccessParams =>
      _db.fetchDeviceAsStream().map((d) => d.isSuper);

  bool get isAnonymous => anonymous;
}

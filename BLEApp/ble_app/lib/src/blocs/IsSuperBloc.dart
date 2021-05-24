import 'package:ble_app/src/blocs/mixins/CurrentContext.dart';
import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsSuperBloc with CurrentContext {
  final LocalDatabaseManager _db;

  const IsSuperBloc(this._db);

  Stream<bool> get authorizedToAccessParams =>
      _db.fetchDeviceAsStream().map((d) => !d.isSuper);

  bool get isAnonymous => anonymous;
}

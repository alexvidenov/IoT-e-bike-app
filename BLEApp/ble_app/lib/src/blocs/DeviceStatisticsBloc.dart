import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/services/Storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeviceStatisticsBloc with CurrentContext {
  Storage get _storage => Storage(uid: curUserId);

  Future<List<LogModel>> fetchData() async => await _storage.download();
}

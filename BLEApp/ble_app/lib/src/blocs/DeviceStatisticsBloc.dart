import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/services/Storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeviceStatisticsBloc extends Bloc<List<LogModel>, void>
    with CurrentContext {
  Storage get _storage =>
      Storage(uid: curUserId, deviceSerialNumber: curDeviceId);

  final List<String> _logFiles = [];

  final nameFetchRx = RxObject<List<String>>();

  DeviceStatisticsBloc() : super();

  Future<List<LogModel>> fetchAll() async => await _storage.downloadAll();

  Future<void> fetchOne(int index) async => await _storage
      .downloadOne(_logFiles.elementAt(index))
      .then((log) => addEvent(log));

  Future<List<String>> fetchFileNames() async =>
      await _storage.fetchList().then((names) {
        _logFiles.addAll(names);
        return nameFetchRx.addEvent(names);
      });
}

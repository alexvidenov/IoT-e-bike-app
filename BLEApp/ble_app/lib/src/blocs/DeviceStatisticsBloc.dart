import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/services/Storage.dart';
import 'package:injectable/injectable.dart';
import 'package:jiffy/jiffy.dart';

enum StatisticsType { Voltage, Charge, Discharge, Temperature }

class DeviceStatisticsState {
  final List<StatisticsType> types;
  final List<LogModel> logs;

  const DeviceStatisticsState({this.types, this.logs});
}

@injectable
class DeviceStatisticsBloc
    extends ParameterAwareBloc<DeviceStatisticsState, void> {
  Storage get _storage =>
      Storage(uid: curUserId, deviceSerialNumber: curDeviceId);

  final List<String> _logFiles = [];

  final nameFetchRx = RxObject<List<String>>();

  final toggleButtonsState = [true, true, true, true];

  final toggleButtonsStateRx = RxObject<List<bool>>();

  DeviceStatisticsBloc() : super() {
    toggleButtonsStateRx.addEvent([true, true, true, true]);
  }

  Future<List<LogModel>> fetchAll() async => await _storage.downloadAll();

  Future<void> fetchOne(int index) async => await _storage
      .downloadOne(_logFiles.elementAt(index))
      .then((log) => addEvent(
          DeviceStatisticsState(types: _getCurrentTypes(), logs: log)));

  Future<List<String>> fetchFileNames() async =>
      await _storage.fetchList().then((names) {
        _logFiles.addAll(names);
        return nameFetchRx.addEvent(names);
      });

  List<StatisticsType> _getCurrentTypes() {
    final List<StatisticsType> types = [];
    for (var i = 0; i < toggleButtonsState.length; i++) {
      if (toggleButtonsState[i]) {
        types.add(StatisticsType.values[i]);
      }
    }
    return types;
  }

  void refreshCurrentStatisticsType() {
    addEvent(DeviceStatisticsState(
      types: _getCurrentTypes(),
      logs: value.logs,
    ));
    toggleButtonsStateRx.addEvent(toggleButtonsState);
  }
}

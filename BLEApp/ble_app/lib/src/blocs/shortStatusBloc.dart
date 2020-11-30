import 'dart:convert';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/sharedPrefsUsersDataModel.dart';

import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/services/Auth.dart';

class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  final DeviceRepository _repository;

  int _uploadTimer = 0;

  AppData _appData;

  ShortStatusBloc(this._repository) : super();

  @override
  pause() {
    _repository.cancel();
    pauseSubscription();
  }

  @override
  resume() {
    _repository.resumeTimer(true);
    resumeSubscription();
  }

  @override
  void create() {
    _initData();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      ShortStatusModel _model = _generateShortStatus(event);
      addEvent(_model);
      _uploadTimer++;
      if (_uploadTimer == 10) {
        _appData.addCurrentRecord({
          'timeStamp': DateTime.now().toString(),
          'stats': {
            'voltage': _model.getTotalVoltage,
            'temp': _model.getTemperature,
            'currentCharge': _model.getCurrentCharge,
            'currentDischarge': _model.getCurrentDischarge,
          }
        });
        _uploadTimer = 0;
        sl<SettingsBloc>()
            .setUserData(jsonEncode(_appData.toJson())); // list of userData
      }
    });
  }

  _initData() {
    String data = sl<SettingsBloc>().getUserData();
    String userId = sl<Auth>().getCurrentUserId();
    String deviceId = DeviceRepository().deviceId;
    data != 'empty'
        ? _appData = AppData.fromJson(jsonDecode(data),
            userId: userId, deviceSerialNumber: deviceId)
        : _appData = AppData(
            userId: sl<Auth>().getCurrentUserId(),
            deviceSerialNumber: DeviceRepository().deviceId);
  }

  ShortStatusModel _generateShortStatus(String rawData) {
    List<String> splittedObject = rawData.split(' ');
    var voltage = double.parse(splittedObject.elementAt(0));
    var currentCharge = double.parse(splittedObject.elementAt(1));
    var currentDischarge = double.parse(splittedObject.elementAt(2));
    var temperature = double.parse(splittedObject.elementAt(3));
    ShortStatusModel shortStatusViewModel = ShortStatusModel();
    shortStatusViewModel.setParameters(
        voltage, currentCharge, currentDischarge, temperature);
    return shortStatusViewModel;
  }
}

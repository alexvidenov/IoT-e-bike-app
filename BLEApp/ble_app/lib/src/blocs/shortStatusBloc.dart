import 'dart:convert';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/main.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';

import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:injectable/injectable.dart';

part '../extensions/ShortStatusParse.dart';

@injectable
class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  final DeviceRepository _repository;
  final SettingsBloc _settingsBloc;
  final Auth _auth;

  int _uploadTimer = 0;

  AppData _appData;

  ShortStatusBloc(this._repository, this._settingsBloc, this._auth) : super();

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
            'voltage': _model.totalVoltage,
            'temp': _model.temperature,
            'currentCharge': _model.currentCharge,
            'currentDischarge': _model.currentDischarge,
          }
        });
        _uploadTimer = 0;
        _settingsBloc
            .setUserData(jsonEncode(_appData.toJson())); // list of userData
      }
    });
  }

  _initData() {
    String data = _settingsBloc.getUserData();
    String userId = _auth.getCurrentUserId();
    String deviceId = _repository.deviceId;
    data != 'empty'
        ? _appData = AppData.fromJson(jsonDecode(data),
            userId: userId, deviceSerialNumber: deviceId)
        : _appData = AppData(userId: userId, deviceSerialNumber: deviceId);
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Short Status Bloc');
    super.dispose();
  }
}


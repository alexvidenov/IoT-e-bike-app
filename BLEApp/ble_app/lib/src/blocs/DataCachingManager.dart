import 'dart:convert';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';

mixin DataCachingManager on CurrentContext {
  final SettingsBloc _settingsBloc = $<SettingsBloc>();
  int _uploadTimer = 0;

  AppData _appData;

  loadData() {
    final data = _settingsBloc.getUserData();
    data != 'empty'
        ? _appData = AppData.fromJson(jsonDecode(data),
            userId: this.curUserId, deviceSerialNumber: this.curDeviceId)
        : _appData = AppData(
            userId: this.curUserId, deviceSerialNumber: this.curDeviceId);
  }

  increaseTimer() {
    _uploadTimer++;
    if (_uploadTimer == 10) {
      _appData.addCurrentRecord({
        'timeStamp': DateTime.now().toString(),
        'stats': {
          //'voltage': _model.model.totalVoltage,
          //'temp': _model.model.temperature,
          //'current': _model.model.current
        }
      });
      _uploadTimer = 0;
      _settingsBloc
          .setUserData(jsonEncode(_appData.toJson())); // list of userData
    }
  }
}

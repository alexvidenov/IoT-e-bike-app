import 'dart:convert';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/BaseStatus.dart';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';
import 'package:flutter/material.dart';

mixin DataCachingManager on CurrentContext {
  final SettingsBloc _settingsBloc = $<SettingsBloc>();

  AppData
      _appData; // appData is continuously evolving even if upload occurs -> we should bind this appData instance to the upload somehow

  loadData() {
    final data = _settingsBloc.getUserData();
    data != 'empty'
        ? _appData = AppData.fromJson(jsonDecode(data),
            userId: this.curUserId, deviceSerialNumber: this.curDeviceId)
        : _appData = AppData(
            userId: this.curUserId, deviceSerialNumber: this.curDeviceId);
  }

  @optionalTypeArgs
  addData<T extends BaseStatus>(T _model) {
    _appData.addCurrentRecord({
      'timeStamp': DateTime.now().toString(),
      'stats': {
        'voltage': _model.totalVoltage,
        'temp': _model.temperature,
        'current': _model.current
      }
    });
    _settingsBloc
        .setUserData(jsonEncode(_appData.toJson())); // list of userData
  }
}

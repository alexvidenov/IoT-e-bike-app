import 'dart:convert';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';
import 'package:ble_app/src/persistence/SembastDatabase.dart';
import 'package:flutter/material.dart';

mixin DataCachingManager<T extends LogModel> on CurrentContext {
  final SembastDatabase _sembastDatabase = $<SembastDatabase>();

  final List<T> _currentModels = [];

  AppData
      _appData; // appData is continuously evolving even if upload occurs -> we should bind this appData instance to the upload somehow

  Future<void> loadData() async {
    final data = await _sembastDatabase.getUserLogData();
    data != null
        ? _appData = AppData.fromJson(jsonDecode(data),
            userId: this.curUserId, deviceSerialNumber: this.curDeviceId)
        : _appData = AppData(
            userId: this.curUserId, deviceSerialNumber: this.curDeviceId);
  }

  void saveLogs() {
    _appData.addCurrentRecords(_currentModels);
    _sembastDatabase.setUserLogData(jsonEncode(_appData.toJson()));
    _currentModels.clear();
  }

  @optionalTypeArgs
  void addCurrentModel<T extends BaseModel>(T model) =>
      _currentModels.add(model.generate());
}

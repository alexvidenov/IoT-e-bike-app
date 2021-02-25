import 'dart:convert';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';
import 'package:ble_app/src/persistence/SembastDatabase.dart';
import 'package:flutter/material.dart';

mixin DataCachingManager on CurrentContext {
  final SembastDatabase _sembastDatabase = $<SembastDatabase>();

  AppData
      _appData; // appData is continuously evolving even if upload occurs -> we should bind this appData instance to the upload somehow

  void loadData() async {
    final data = await _sembastDatabase.getUserLogData();
    data != null
        ? _appData = AppData.fromJson(jsonDecode(data),
            userId: this.curUserId, deviceSerialNumber: this.curDeviceId)
        : _appData = AppData(
            userId: this.curUserId, deviceSerialNumber: this.curDeviceId);
  }

  @optionalTypeArgs
  void addData<T extends BaseModel>(T _model) {
    LogModel log = _model.generate();
    _appData.addCurrentRecord(log);
    _sembastDatabase
        .setUserLogData(jsonEncode(_appData.toJson())); // list of userData
  }

  @optionalTypeArgs
  void addListData<T extends BaseModel>(List<T> models) {
    _appData.addCurrentRecords(models.map((e) => e.generate()).toList());
    _sembastDatabase.setUserLogData(jsonEncode(_appData.toJson()));
  }
}

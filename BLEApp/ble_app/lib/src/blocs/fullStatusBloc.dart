import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/mixins/DeltaHolder.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusModel.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'DataCachingManager.dart';

part 'blocExtensions/FullStatusParse.dart';

@injectable
class FullStatusBloc extends ParameterAwareBloc<FullStatusModel, String>
    with DeltaCalculation, CurrentContext, DataCachingManager {
  final DeviceRepository _repository;

  final tempConverter = TemperatureConverter();

  int _uploadTimer = 0;

  FullStatusBloc(this._repository) : super();

  @override
  create() {
    loadData();
    streamSubscription = _repository.characteristicValueStream.listen((e) {
      //final _model = _generateFullStatus(e);
      addEvent(_generateFullStatus(e));
      _uploadTimer++;
      if (_uploadTimer == 10) {
        _uploadTimer = 0;
        //addData(_model);
      }
    });
  }

  @override
  pause() {
    _repository.cancel();
    super.pause();
  }

  @override
  resume() {
    _repository.resumeTimer(false); // change this boolean please
    super.resume();
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Full Status Bloc');
    super.dispose();
  }
}

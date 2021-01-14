import 'dart:async';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/main.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part '../extensions/FullStatusParse.dart';

@injectable
class FullStatusBloc
    extends ParameterAwareBloc<List<FullStatusDataModel>, String> {
  final DeviceRepository _repository;

  FullStatusBloc(this._repository) : super();

  @override
  create() => streamSubscription =
      _repository.characteristicValueStream.listen(addEvent);

  @override
  pause() {
    _repository.cancel();
    pauseSubscription();
  }

  @override
  resume() {
    _repository.resumeTimer(false); // change this boolean please
    resumeSubscription();
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Full Status Bloc');
    super.dispose();
  }

  @override
  mapEventToState(data, EventSink<List<FullStatusDataModel>> sink) {
    sink.add(_generateFullStatus(data));
  }
}

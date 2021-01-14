import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/main.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'ParameterAware.dart';
import 'ParameterAwareBloc.dart';

part '../extensions/FullStatusParse.dart';

@injectable
class FullStatusBloc extends Bloc<List<FullStatusDataModel>, String> {
  final DeviceRepository _repository;

  FullStatusBloc(this._repository) : super();

  @override
  void create() => _listenToFullStatus();

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

  _listenToFullStatus() {
    streamSubscription = _repository.characteristicValueStream
        .listen((event) => // if(event.length > someArbitrary shit)
            addEvent(_generateFullStatus(event)));
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Full Status Bloc');
    super.dispose();
  }
}

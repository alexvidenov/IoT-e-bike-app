import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusModel.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'blocExtensions/FullStatusParse.dart';

@injectable
class FullStatusBloc extends ParameterAwareBloc<FullStatusModel, String> {
  final DeviceRepository _repository;

  final delta1Holder = RxObject<double>();
  final delta2Holder = RxObject<double>();

  final tempConverter = TemperatureConverter();

  int deltaCounter = 0;

  FullStatusBloc(this._repository) : super();

  @override
  create() => streamSubscription = _repository.characteristicValueStream
      .listen((e) => addEvent(_generateFullStatus(e)));

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

import 'dart:convert';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/DataCachingManager.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';

import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/sealedStates/shortStatusState.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:injectable/injectable.dart';

part 'blocExtensions/ShortStatusParse.dart';

@injectable
class ShortStatusBloc extends ParameterAwareBloc<ShortStatusState, String>
    with CurrentContext, DataCachingManager {
  final DeviceRepository _repository;

  final tempConverter = TemperatureConverter();

  int _uploadTimer = 0;

  ShortStatusBloc(this._repository) : super();

  @override
  pause() {
    super.pause();
    _repository.cancel();
  }

  @override
  resume() {
    super.resume();
    _repository.resumeTimer(true);
  }

  @override
  create() {
    loadData();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      logger.wtf('SHORT STATUS EVENT: $event');
      ShortStatusState _model = _generateShortStatus(
          event); // TODO: add method checking for abnormalities.
      addEvent(_generateShortStatus(event));
      //addEvent(ShortStatusState.error(, errorState))
      _uploadTimer++;
      if (_uploadTimer == 10) {
        _uploadTimer = 0;
        addData<ShortStatus>(_model.model);
      }
    });
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Short Status Bloc');
    super.dispose();
  }
}

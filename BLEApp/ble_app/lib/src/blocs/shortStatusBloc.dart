import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';

import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/utils/Converter.dart';

class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  final DeviceRepository _repository;

  ShortStatusBloc(this._repository) : super();

  _listenToShortStatus() {
    streamSubscription = _repository.characteristicValueStream
        .listen((event) => addEvent(Converter.generateShortStatus(event)));
  }

  init() => _listenToShortStatus();

  startGeneratingShortStatus() {
    _repository.periodicShortStatus();
  }

  dynamic pause() {
    _repository.cancel();
    pauseSubscription();
  }

  dynamic resume() {
    _repository.resumeTimer(true);
    resumeSubscription();
  }
}

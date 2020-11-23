import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';

import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/utils/Converter.dart';

class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  final DeviceRepository _repository;

  ShortStatusBloc(this._repository) : super();

  @override
  pause() {
    _repository.cancel();
    pauseSubscription();
  }

  @override
  resume() {
    _repository.resumeTimer(true);
    resumeSubscription();
  }

  @override
  void create() => streamSubscription = _repository.characteristicValueStream
      .listen((event) => addEvent(Converter.generateShortStatus(event)));
}

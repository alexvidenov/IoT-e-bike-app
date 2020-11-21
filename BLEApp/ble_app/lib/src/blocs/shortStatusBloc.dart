import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/data/DeviceRepository.dart';
import 'package:get_it/get_it.dart';

import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/utils.dart';

class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  final repository = GetIt.I<DeviceRepository>();

  ShortStatusBloc();

  _listenToShortStatus() {
    streamSubscription = repository.characteristicValueStream
        .listen((event) => addEvent(Converter.generateShortStatus(event)));
  }

  startGeneratingShortStatus() {
    repository.periodicShortStatus();
    _listenToShortStatus();
  }

  dynamic cancel() {
    repository.cancel();
    pauseSubscription();
  }

  dynamic resume() {
    repository.resumeTimer(true);
    resumeSubscription();
  }
}

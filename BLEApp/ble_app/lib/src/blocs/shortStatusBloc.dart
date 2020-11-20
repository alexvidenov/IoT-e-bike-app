import 'package:ble_app/src/blocs/bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:ble_app/src/utils.dart';

class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  final repository = GetIt.I<BluetoothRepository>();

  ShortStatusBloc();

  _listenToShortStatus() {
    streamSubscription = repository
        .characteristicValueStream // I guess we gotta make streams for..everything.
        .listen((event) => addEvent(Converter.generateShortStatus(event)));
  }

  startGeneratingShortStatus() {
    repository.periodicShortStatus();
    _listenToShortStatus();
  }

  dynamic cancel() {
    repository
        .cancelTimer(); // later on have different timers, depending on short / full status
    pauseSubscription();
  }

  dynamic resume() {
    repository.resumeTimer(true);
    resumeSubscription();
  }
}

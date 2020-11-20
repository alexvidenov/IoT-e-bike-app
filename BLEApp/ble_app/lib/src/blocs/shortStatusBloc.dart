import 'package:ble_app/src/blocs/bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:ble_app/src/utils.dart';

class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  ShortStatusBloc() {
    streamSubscription = GetIt.I<BluetoothRepository>()
        .characteristicValueStream
        .listen((event) => addEvent(Converter.generateShortStatus(event)));
  }

  dynamic cancel() {
    GetIt.I<BluetoothRepository>()
        .cancelTimer(); // later on have different timers, depending on short / full status
    pauseSubscription();
  }

  resume() {
    resumeSubscription();
    GetIt.I<BluetoothRepository>().resumeTimer();
  }
}

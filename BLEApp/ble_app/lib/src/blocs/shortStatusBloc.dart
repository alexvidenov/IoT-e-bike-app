import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'package:ble_app/src/blocs/StreamOwner.dart';
import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:ble_app/src/utils.dart';

class ShortStatusBloc extends StreamOwner {
  final _shortStatus$ = BehaviorSubject<ShortStatusModel>();

  Stream<ShortStatusModel> get shortStatus => _shortStatus$.stream;

  StreamSubscription<String> _characteristicSubscription;

  ShortStatusBloc() {
    // convert to factory
    _characteristicSubscription = GetIt.I<BluetoothRepository>()
        .characteristicValueStream
        .listen((event) {
      var model = Converter.generateShortStatus(event);
      _shortStatus$.sink.add(model);
    });
  }

  cancel() {
    GetIt.I<BluetoothRepository>()
        .cancelTimer(); // later on have different timers, depending on short / full status
    _characteristicSubscription.pause();
  }

  resume() {
    _characteristicSubscription.resume();
    GetIt.I<BluetoothRepository>().resumeTimer();
  }

  @override
  void dispose() {
    _shortStatus$.close();
    GetIt.I<BluetoothRepository>().dispose();
  }
}

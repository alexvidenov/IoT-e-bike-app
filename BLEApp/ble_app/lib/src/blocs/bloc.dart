import 'dart:async';

import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<T, S> {
  // T, S, R
  // data, stream subscription, and repository
  final behaviourSubject$ = BehaviorSubject<T>();

  Stream<T> get stream => behaviourSubject$.stream; // should expose only that!!

  Sink<T> get sink => behaviourSubject$.sink;

  StreamSubscription<S> streamSubscription;

  addEvent(T event) => sink.add(event);

  // eventually implement constructor calling generic Stream getter. Type of repo is R

  pauseSubscription() {
    streamSubscription.pause();
  }

  resumeSubscription() {
    streamSubscription.resume();
  }

  void dispose() {
    behaviourSubject$.close();
    GetIt.I<BluetoothRepository>()
        .dispose(); // the Bluetooth repository class will be the R generic
  }
}

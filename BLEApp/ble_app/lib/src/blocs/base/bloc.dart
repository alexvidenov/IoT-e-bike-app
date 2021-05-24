import 'package:ble_app/src/blocs/base/RxObject.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<T, S> with RxObject<T> {
  // state and event
  // T, S

  StreamSubscription<S> streamSubscription;

  Bloc() {
    this.behaviourSubject = BehaviorSubject<T>();
  }

  create() {}

  pause() => streamSubscription?.pause();

  resume() => streamSubscription?.resume();

  @mustCallSuper
  dispose() {
    super.dispose();
    streamSubscription?.cancel();
  }
}

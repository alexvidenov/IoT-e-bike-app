import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<T, S> {
  // state and event
  // T, S

  BehaviorSubject<T> _behaviorSubject;

  Stream<T> get stream => _behaviorSubject.stream;

  Sink<T> get _sink => _behaviorSubject.sink;

  StreamSubscription<S> streamSubscription;

  Bloc() {
    this._behaviorSubject = BehaviorSubject<T>();
  }

  void create() {}

  void pause() {}

  void resume() {}

  Function(T) get addEvent => _sink.add;

  pauseSubscription() => streamSubscription?.pause();

  resumeSubscription() => streamSubscription.resume();

  @mustCallSuper
  void dispose() {
    streamSubscription?.cancel();
    _behaviorSubject?.close();
  }
}

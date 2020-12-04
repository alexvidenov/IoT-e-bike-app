import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

mixin Disposable<T, S> {
  StreamSubscription<S> streamSubscription;

  BehaviorSubject<T> _publishSubject$;

  @mustCallSuper
  void dispose() {
    streamSubscription?.cancel();
    _publishSubject$?.close();
  }
}

abstract class Bloc<T, S> with Disposable<T, S> {
  // state and event
  // T, S

  Stream<T> get stream => _publishSubject$.stream;

  Sink<T> get _sink => _publishSubject$.sink;

  Bloc() {
    this._publishSubject$ = BehaviorSubject<T>();
  }

  void create() {}

  void pause() {}

  void resume() {}

  Function(T) get addEvent => _sink.add;

  pauseSubscription() => streamSubscription?.pause();

  resumeSubscription() => streamSubscription.resume();
}

import 'package:ble_app/src/blocs/ParameterAwareBloc.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

mixin _Disposable<T, S> {
  StreamSubscription<S> streamSubscription;

  BehaviorSubject<T> _publishSubject$;

  @mustCallSuper
  dispose() {
    streamSubscription?.cancel();
    _publishSubject$?.close();
  }
}

abstract class Bloc<T, S> with _Disposable<T, S> {
  // state and event
  // T, S

  Stream<T> get stream => _publishSubject$.stream;

  Sink<T> get _sink => _publishSubject$.sink;

  Bloc() {
    this._publishSubject$ = BehaviorSubject<T>();
  }

  create() {}

  pause() {}

  resume() {}

  Function(T) get addEvent => _sink.add;

  pauseSubscription() => streamSubscription?.pause();

  resumeSubscription() => streamSubscription?.resume();
}

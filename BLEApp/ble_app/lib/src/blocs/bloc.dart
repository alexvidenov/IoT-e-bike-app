import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<T, S> {
  // state and event
  // T, S

  StreamSubscription<S> streamSubscription;

  BehaviorSubject<T> _publishSubject$;

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

  @mustCallSuper
  dispose() {
    streamSubscription?.cancel();
    _publishSubject$?.close();
  }
}

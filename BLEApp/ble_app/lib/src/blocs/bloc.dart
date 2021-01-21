import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class StreamHolder<T> {
  BehaviorSubject<T> _publishSubject$ = BehaviorSubject<T>();

  Stream<T> get stream => _publishSubject$.stream;

  Sink<T> get _sink => _publishSubject$.sink;

  Function(T) get addEvent => _sink.add;

  @mustCallSuper
  dispose() {
    _publishSubject$.close();
  }
}

abstract class Bloc<T, S> with StreamHolder<T> {
  // state and event
  // T, S

  StreamSubscription<S> streamSubscription;

  Bloc() {
    this._publishSubject$ = BehaviorSubject<T>();
  }

  create() {}

  pause() => _pauseSubscription();

  resume() => _resumeSubscription();

  _pauseSubscription() => streamSubscription?.pause();

  _resumeSubscription() => streamSubscription?.resume();

  @mustCallSuper
  dispose() {
    super.dispose();
    streamSubscription?.cancel();
  }
}

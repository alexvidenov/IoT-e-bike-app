import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class Bloc<T, S> {
  // state and event
  // T, S

  PublishSubject<T> _publishSubject$;

  Stream<T> get stream => _publishSubject$.stream;

  Sink<T> get _sink => _publishSubject$.sink;

  StreamSubscription<S> streamSubscription;

  Bloc() {
    this._publishSubject$ = PublishSubject<T>();
  }

  void create();

  void pause();

  void resume();

  addEvent(T event) => _sink.add(event);

  pauseSubscription() {
    streamSubscription?.pause();
  }

  resumeSubscription() {
    streamSubscription.resume();
  }

  void dispose() {
    streamSubscription?.cancel();
    _publishSubject$?.close();
  }
}

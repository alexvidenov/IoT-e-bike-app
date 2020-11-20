import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class Bloc<T, S> {
  // state and event
  // T, S, R
  // data, stream subscription, and repository
  final _behaviourSubject$ = BehaviorSubject<T>();

  Stream<T> get stream =>
      _behaviourSubject$.stream; // should expose only that!!

  Sink<T> get _sink => _behaviourSubject$.sink;

  StreamSubscription<S> streamSubscription;

  addEvent(T event) => _sink.add(event);

  // eventually implement constructor calling generic Stream getter. Type of repo is R

  pauseSubscription() {
    streamSubscription?.pause();
  }

  resumeSubscription() {
    streamSubscription?.resume();
  }

  void dispose() {
    streamSubscription?.cancel();
    _behaviourSubject$?.close();
  }
}

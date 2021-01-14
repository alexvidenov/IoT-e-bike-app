import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

// state and event
// T, S
abstract class Bloc<T, S> {
  // transformer
  StreamTransformer<S, T> _transformer;

  BehaviorSubject<S> _behaviourSubject$;

  StreamSubscription<S> streamSubscription;

  Stream<T> get stream =>
      _behaviourSubject$.stream.transform(
          _transformer); // TODO: try to add Rx.merge for internal stream and externally-triggred stream

  Sink<S> get _sink => _behaviourSubject$.sink;

  Bloc(T initialState) {
    this._behaviourSubject$ = BehaviorSubject<T>.seeded(initialState); // THINK OF THAAT
    _transformer = StreamTransformer.fromHandlers(handleData: mapEventToState);
  }

  // mapper
  mapEventToState(data, EventSink<T> sink) =>
      sink.add(data); // default implementation. Emits same stream as the event

  create() {}

  pause() {}

  resume() {}

  Function(S) get addEvent => _sink.add;

  pauseSubscription() => streamSubscription?.pause();

  resumeSubscription() => streamSubscription?.resume();

  @mustCallSuper
  dispose() {
    streamSubscription?.cancel();
    _behaviourSubject$?.close();
  }
}

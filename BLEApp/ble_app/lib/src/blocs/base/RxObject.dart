import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RxObject<T> {
  BehaviorSubject<T> behaviourSubject = BehaviorSubject<T>();

  T get value => stream.value;

  ValueStream<T> get stream => behaviourSubject.stream;

  Sink<T> get _sink => behaviourSubject.sink;

  Function(T) get addEvent => _sink.add;

  @mustCallSuper
  dispose() => behaviourSubject.close();
}

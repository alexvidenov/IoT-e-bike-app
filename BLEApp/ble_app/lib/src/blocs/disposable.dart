part of bloc; 

mixin _Disposable<T, S> {
  StreamSubscription<S> streamSubscription;

  BehaviorSubject<T> _publishSubject$;

  @mustCallSuper
  dispose() {
    streamSubscription?.cancel();
    _publishSubject$?.close();
  }
}
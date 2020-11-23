import 'package:rxdart/rxdart.dart';

class NavigationBloc {
  BehaviorSubject<int> _stackIndexController;
  Stream<int> get stackIndex => _stackIndexController.stream;
  Sink<int> get _setStackIndex => _stackIndexController.sink;

  Function(int) get setStackIndex => _setStackIndex.add;

  NavigationBloc() {
    _stackIndexController = BehaviorSubject<int>();
  }

  void dispose() {
    _stackIndexController.close();
  }
}

import 'package:rxdart/rxdart.dart';

enum CurrentPage { Short, Full, Map }

class NavigationBloc {
  BehaviorSubject<CurrentPage> _pageController;
  Stream<CurrentPage> get page => _pageController.stream;
  Sink<CurrentPage> get _setPage => _pageController.sink;

  Function(CurrentPage) get setCurrentPage => _setPage.add;

  NavigationBloc() {
    _pageController = BehaviorSubject<CurrentPage>();
  }

  void dispose() {
    _pageController.close();
  }
}

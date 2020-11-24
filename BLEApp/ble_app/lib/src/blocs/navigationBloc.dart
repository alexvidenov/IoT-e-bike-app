import 'package:ble_app/src/blocs/navigationService.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum CurrentPage { Short, Full, Map }

class NavigationBloc {
  final NavigationService _navigationService;

  NavigationBloc(this._navigationService) {
    _pageController = BehaviorSubject<CurrentPage>();
  }

  GlobalKey<NavigatorState> get navigatorKey =>
      _navigationService.innerNavigatorKey;

  BehaviorSubject<CurrentPage> _pageController;
  Stream<CurrentPage> get page => _pageController.stream;
  Sink<CurrentPage> get _setPage => _pageController.sink;

  Function(CurrentPage) get setCurrentPage => _setPage.add;

  navigateTo(String routeName) => _navigationService.innerNavigateTo(routeName);

  returnToFirstRoute() => _navigationService.returnToFirstInner();

  generateGlobalKey() => _navigationService.generateGlobalKey();

  void dispose() => _pageController.close();
}

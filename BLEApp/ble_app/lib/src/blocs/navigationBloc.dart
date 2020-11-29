import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/navigationService.dart';
import 'package:flutter/material.dart';

enum CurrentPage { Short, Full, Map }

class NavigationBloc extends Bloc<CurrentPage, CurrentPage> {
  final NavigationService _navigationService;

  NavigationBloc(this._navigationService) : super();

  GlobalKey<NavigatorState> get navigatorKey =>
      _navigationService.innerNavigatorKey;

  navigateTo(String routeName) => _navigationService.innerNavigateTo(routeName);

  returnToFirstRoute() => _navigationService.returnToFirstInner();

  generateGlobalKey() => _navigationService.generateGlobalKey();
}
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/navigationService.dart';
import 'package:ble_app/main.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum CurrentPage { ShortStatus, Controller, Map }

@lazySingleton
class NavigationBloc extends Bloc<CurrentPage, CurrentPage> {
  final NavigationService _navigationService;

  NavigationBloc(this._navigationService) : super();

  GlobalKey<NavigatorState> get navigatorKey =>
      _navigationService.innerNavigatorKey;

  to(String routeName) => _navigationService.innerNavigateTo(routeName);

  returnToFirstRoute() => _navigationService.returnToFirstInner();

  generateGlobalKey() => _navigationService.generateGlobalKey();

  @override
  dispose() {
    super.dispose();
    logger.wtf('Closing stream in NavigationBloc');
  }
}

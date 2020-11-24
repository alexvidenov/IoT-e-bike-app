import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _navigationService =
      NavigationService._internal();

  NavigationService._internal();

  factory NavigationService() => _navigationService;

  GlobalKey<NavigatorState> innerNavigatorKey;

  generateGlobalKey() => innerNavigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> innerNavigateTo(String routeName) =>
      innerNavigatorKey.currentState.pushNamed(routeName);

  Future<dynamic> returnToFirstInner() =>
      innerNavigatorKey.currentState.pushNamedAndRemoveUntil('/', (_) => false);
}

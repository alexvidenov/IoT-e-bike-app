import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> innerNavigatorKey;

  generateGlobalKey() => innerNavigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> innerNavigateTo(String routeName) =>
      innerNavigatorKey.currentState.pushNamed(routeName);

  Future<dynamic> returnToFirstInner() =>
      innerNavigatorKey.currentState.pushNamedAndRemoveUntil('/', (_) => false);
}

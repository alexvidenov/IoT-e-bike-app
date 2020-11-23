import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> innerNavigatorKey;

  generateGlobalKey() => innerNavigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> innerNavigateTo(String routeName) =>
      innerNavigatorKey.currentState.pushNamed(routeName);

  returnToFirstInner() => innerNavigatorKey.currentState
      .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => route.isFirst);
}

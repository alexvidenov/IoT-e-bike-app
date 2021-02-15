import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigationService {
  GlobalKey<NavigatorState> innerNavigatorKey;

  generateGlobalKey() => innerNavigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> innerNavigateTo(String routeName) =>
      innerNavigatorKey.currentState.pushNamed(routeName); // FIXME REFACTOR THIS

  Future<dynamic> returnToFirstInner() =>
      innerNavigatorKey.currentState.pushNamedAndRemoveUntil('/', (_) => false);
}

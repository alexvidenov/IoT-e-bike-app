import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/fullStatusPage.dart';
import 'package:ble_app/src/screens/googleMapsPage.dart';
import 'package:ble_app/src/screens/shortStatusPage.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => DeviceScreen(locator<ShortStatusBloc>()));
      case '/full':
        return MaterialPageRoute(
            builder: (_) =>
                FullStatusPage(Key('Full Status'), locator<FullStatusBloc>()));
      case '/map':
        return MaterialPageRoute(
            builder: (_) => MapPage(Key('Map Page'), locator<LocationBloc>()));
    }
  }
}

import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/authenticationPage.dart';
import 'package:ble_app/src/screens/devicesListScreen.dart';
import 'package:ble_app/src/screens/fullStatusPage.dart';
import 'package:ble_app/src/screens/googleMapsPage.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:ble_app/src/screens/settingsPage.dart';
import 'package:ble_app/src/screens/shortStatusPage.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRouteSecondNavigator(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => DeviceScreen(Injector.$()));
      case '/full':
        return MaterialPageRoute(
            builder: (_) => FullStatusPage(Injector.$()));
      case '/map':
        return MaterialPageRoute(
            builder: (_) => MapPage(Injector.$(), Injector.$()));
    }
  }

  static Route<dynamic> generateRouteMainNavigatorStartsWithAuth(
      RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => AuthenticationScreen(Injector.$(),
                Injector.$(), Injector.$()));
      case '/home':
        return MaterialPageRoute(
            builder: (_) => HomeScreen(Injector.$(),
                Injector.$(), Injector.$()));
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings(Injector.$(), Injector.$()));
      case '/devices':
        return MaterialPageRoute(
            builder: (_) => DevicesListScreen(Injector.$()));
      case '/auth':
        return MaterialPageRoute(
            builder: (_) => AuthenticationScreen(Injector.$(),
                Injector.$(), Injector.$()));
    }
  }

  static Route<dynamic> generateRouteMainNavigatorStartsWithDevices(
      RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => DevicesListScreen(Injector.$()));
      case '/auth':
        return MaterialPageRoute(
            builder: (_) => AuthenticationScreen(Injector.$(),
                Injector.$(), Injector.$()));
      case '/home':
        return MaterialPageRoute(
            builder: (_) => HomeScreen(Injector.$(),
                Injector.$(), Injector.$()));
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings(Injector.$(), Injector.$()));
      case '/devices':
        return MaterialPageRoute(
            builder: (_) => DevicesListScreen(Injector.$()));
    }
  }
}

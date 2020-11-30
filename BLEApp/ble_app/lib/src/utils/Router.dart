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
            builder: (_) => DeviceScreen(sl()));
      case '/full':
        return MaterialPageRoute(
            builder: (_) => FullStatusPage(sl()));
      case '/map':
        return MaterialPageRoute(
            builder: (_) => MapPage(sl()));
    }
  }

  static Route<dynamic> generateRouteMainNavigatorStartsWithAuth(
      RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => AuthenticationScreen(sl(),
                sl(), sl()));
      case '/home':
        return MaterialPageRoute(
            builder: (_) => HomeScreen(sl(),
                sl(), sl()));
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings(sl(), sl()));
      case '/devices':
        return MaterialPageRoute(
            builder: (_) => DevicesListScreen(sl()));
      case '/auth':
        return MaterialPageRoute(
            builder: (_) => AuthenticationScreen(sl(),
                sl(), sl()));
    }
  }

  static Route<dynamic> generateRouteMainNavigatorStartsWithDevices(
      RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => DevicesListScreen(sl()));
      case '/auth':
        return MaterialPageRoute(
            builder: (_) => AuthenticationScreen(sl(),
                sl(), sl()));
      case '/home':
        return MaterialPageRoute(
            builder: (_) => HomeScreen(sl(),
                sl(), sl()));
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings(sl(), sl()));
      case '/devices':
        return MaterialPageRoute(
            builder: (_) => DevicesListScreen(sl()));
    }
  }
}

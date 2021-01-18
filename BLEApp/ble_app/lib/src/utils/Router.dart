import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/screens/parameterFetchScreen.dart';
import 'package:ble_app/src/screens/authentication/bleAuthenticationPage.dart';
import 'package:ble_app/src/screens/devicesListScreen.dart';
import 'package:ble_app/src/screens/main/fullStatusPage.dart';
import 'package:ble_app/src/screens/main/googleMapsPage.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:ble_app/src/screens/settings/BatterySettings.dart';
import 'package:ble_app/src/screens/settings/settingsPage.dart';
import 'package:ble_app/src/screens/main/shortStatusPage.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:flutter/material.dart';

class _PathError extends StatelessWidget {
  const _PathError({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
}

abstract class Router {
  static Route<dynamic> generateRouteSecondNavigator(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => DeviceScreen($()));
      case '/full':
        return MaterialPageRoute(builder: (_) => FullStatusPage($()));
      case '/map':
        return MaterialPageRoute(builder: (_) => MapPage($()));
    }
    return MaterialPageRoute(builder: (_) => _PathError());
  }

  static Route<dynamic> generateRouteMainNavigatorStartsWithAuth(
      RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BLEAuthenticationScreen($(), $(), $()));
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen($(), $(), $()));
      case '/settings':
        return MaterialPageRoute(
            builder: (_) => ConnectionSettingsScreen($(), $()));
      case '/devices':
        return MaterialPageRoute(
            builder: (_) => DevicesListScreen($(), $<Auth>().signOut));
      case '/auth':
        return MaterialPageRoute(
            builder: (_) => BLEAuthenticationScreen($(), $(), $()));
      case '/fetchParameters':
        return MaterialPageRoute(
            builder: (_) => ParameterFetchScreen(
                $(), $(), $(), $<DeviceRepository>().deviceId));
      case '/batterySettings':
        return MaterialPageRoute(
            builder: (_) => BatterySettingsScreen($(), $(), $(), $()));
    }
    return MaterialPageRoute(builder: (_) => _PathError());
  }

  static Route<dynamic> generateRouteMainNavigatorStartsWithDevices(
      RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => DevicesListScreen($(), $<Auth>().signOut));
      case '/auth':
        return MaterialPageRoute(
            builder: (_) => BLEAuthenticationScreen($(), $(), $()));
      case '/fetchParameters':
        return MaterialPageRoute(
            builder: (_) => ParameterFetchScreen(
                $(), $(), $(), $<DeviceRepository>().deviceId));
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen($(), $(), $()));
      case '/settings':
        return MaterialPageRoute(
            builder: (_) => ConnectionSettingsScreen($(), $()));
      case '/devices':
        return MaterialPageRoute(
            builder: (_) => DevicesListScreen($(), $<Auth>().signOut));
      case '/batterySettings':
        return MaterialPageRoute(
            builder: (_) => BatterySettingsScreen($(), $(), $(), $()));
    }
    return MaterialPageRoute(builder: (_) => _PathError());
  }
}

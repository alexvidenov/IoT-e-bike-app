import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/authentication/authenticationWrapper.dart';
import 'package:ble_app/src/screens/authentication/bleAuthenticationPage.dart';
import 'package:ble_app/src/screens/devicesListScreen.dart';
import 'package:ble_app/src/screens/entrypoints/Mode.dart';
import 'package:ble_app/src/screens/entrypoints/Root.dart';
import 'package:ble_app/src/screens/entrypoints/WelcomeScreen.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:ble_app/src/screens/parameterFetchScreen.dart';
import 'package:ble_app/src/screens/settings/BatterySettings.dart';
import 'package:ble_app/src/screens/settings/settingsPage.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PageManager {
  final _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  PageManager() {
    print('INITIALIZING');
    pages.addEvent(_pages);
  }

  final pages = RxObject<List<Page>>();

  List<Page> get _pagesList => List.unmodifiable(_pages);

  final List<Page> _pages = [
    MaterialPage(
      child: DetermineEndpointWidget($(), $()),
      key: Key('MainPage'),
    ),
  ];

  void openWelcomeScreen(Function(Mode) func) {
    _pages.add(MaterialPage(child: Welcome(func: func), key: Key('Welcome')));
    pages.addEvent(_pagesList);
  }

  void openBleApp() {
    _pages.removeWhere(
      (page) =>
          page.key == const Key('Welcome') &&
          page.key ==
              const Key(
                  'AuthWrapper'), // TODO: remove where the key is NOT welcome or the auth wrapper or the other thing
    );
    _pages.add(MaterialPage(child: BleApp($()), key: Key('BleApp')));
    pages.addEvent(_pagesList);
  }

  void openBleAuth() {
    _pages.add(MaterialPage(
        child: BLEAuthenticationScreen($(), $(), $()), key: Key('Ble auth')));
    pages.addEvent(_pagesList);
  }

  void openDevicesListScreen() {
    _pages.add(MaterialPage(
        child: DevicesListScreen($(), $<Auth>().signOut),
        key: Key('DevicesListScreen')));
    pages.addEvent(_pagesList);
  }

  void openParameters() {
    _pages.add(MaterialPage(
        child: ParameterFetchScreen($(), $()),
        key: Key('ParameterFetchScreen')));
    pages.addEvent(_pagesList);
  }

  void openHome() {
    _pages.removeAt(_pages.length - 1);
    _pages.removeAt(_pages.length - 1);
    _pages.add(MaterialPage(
        child: HomeScreen($(), $(), $(), $(), $()), key: Key('Home')));
    pages.addEvent(_pagesList);
  }

  void openAuthWrapper(Function(Mode) func) {
    _pages.removeWhere((page) =>
        page.key != const Key('AuthWrapper') &&
        page.key != const Key('MainPage'));
    _pages.add(MaterialPage(
        child: AuthenticationWrapper($()), key: Key('AuthWrapper')));
    _pages.insert(_pages.length - 1,
        MaterialPage(child: Welcome(func: func), key: Key('Welcome')));
    pages.addEvent(_pagesList);
  }

  void openDeviceSettings() {
    _pages.add(MaterialPage(
        child: BatterySettingsScreen($(), $()), key: Key('BatterySettings')));
    pages.addEvent(_pagesList);
  }

  void openConnectionSettings() {
    _pages.add(MaterialPage(
        child: ConnectionSettingsScreen($(), $(), $()),
        key: Key('ConnectionSettings')));
    pages.addEvent(_pagesList);
  }

  void didPop(Page page, dynamic result) {
    _pages.remove(page);
    pages.addEvent(_pages);
  }
}

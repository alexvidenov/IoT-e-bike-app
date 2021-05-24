import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/base/RxObject.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/main/status/fullStatusPage.dart';
import 'package:ble_app/src/screens/offline/OfflineHome.dart';
import 'package:ble_app/src/screens/serviceContactScreen.dart';
import 'package:ble_app/src/screens/authentication/authenticationWrapper.dart';
import 'package:ble_app/src/screens/authentication/bleAuthenticationPage.dart';
import 'package:ble_app/src/screens/devicesListScreen.dart';
import 'package:ble_app/src/screens/entrypoints/AuthAction.dart';
import 'package:ble_app/src/screens/entrypoints/Root.dart';
import 'package:ble_app/src/screens/entrypoints/WelcomeScreen.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:ble_app/src/screens/main/DeviceStatistics.dart';
import 'package:ble_app/src/screens/parameterFetchScreen.dart';
import 'package:ble_app/src/screens/settings/BatterySettings.dart';
import 'package:ble_app/src/screens/settings/ConnectionSettingsScreen.dart';
import 'package:ble_app/src/screens/settings/SettingViewsHolder.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

mixin OnPagePopped {
  void onPagePop(Key pageKey);
}

enum CurrentPage { ShortStatus, FullStatus, Map }

@lazySingleton
class PageManager {
  final _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  OnPagePopped _onPagePopped;

  PageManager() {
    pages.addEvent(_pages);
  }

  set onPagePopped(OnPagePopped onPagePopped) => _onPagePopped = onPagePopped;

  final pages = RxObject<List<Page>>();

  List<Page> get _pagesList => List.unmodifiable(_pages);

  BuildContext get context => _navigatorKey.currentState.context;

  final List<Page> _pages = [
    MaterialPage(
      child: DetermineEndpointWidget($(), $()),
      key: Key('MainPage'),
    ),
  ];

  void openWelcomeScreen(Function(AuthAction) func) {
    _pages.add(MaterialPage(child: Welcome(func: func), key: Key('Welcome')));
    pages.addEvent(_pagesList);
  }

  void openBleApp() {
    _pages.removeWhere(
      (page) =>
          page.key == const Key('Welcome') ||
          page.key ==
              const Key(
                  'AuthWrapper'), // TODO: remove where the key is NOT welcome or the auth wrapper or the other thing
    );
    _pages.add(MaterialPage(child: BleApp($()), key: Key('BleApp')));
    pages.addEvent(_pagesList);
  }

  void openBleAuth() {
    print('OPENING BLE AUTH');
    if (!_pages.any((page) => page.key == const Key('Ble auth'))) {
      _pages.add(MaterialPage(
          child: BLEAuthenticationScreen($(), $(), $()), key: Key('Ble auth')));
      if (!_pages.any((page) => page.key == const Key('DevicesListScreen'))) {
        _pages.insert(
            _pages.length - 1,
            MaterialPage(
                child: DevicesListScreen($(), $<Auth>().signOut),
                key: Key('DevicesListScreen')));
      }
      pages.addEvent(_pagesList);
    }
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
        child: Home($(), $(), $(), $(), $(), $(), $()), key: Key('Home')));
    pages.addEvent(_pagesList);
  }

  void openAuthWrapper(bool shouldShowLogin, Function(AuthAction) func) {
    _pages.removeWhere((page) =>
        page.key != const Key('AuthWrapper') &&
        page.key != const Key('MainPage'));
    _pages.add(MaterialPage(
        child: AuthenticationWrapper($(), shouldShowLogin),
        key: Key('AuthWrapper')));
    _pages.insert(_pages.length - 1,
        MaterialPage(child: Welcome(func: func), key: Key('Welcome')));
    pages.addEvent(_pagesList);
  }

  void openSettings() {
    _pages.add(MaterialPage(
        child: SettingViewsHolder(), key: Key('SettingViewsHolder')));
    pages.addEvent(_pagesList);
  }

  void openDeviceStatistics() {
    _pages.add(MaterialPage(
        child: DeviceStatisticsScreen($()), key: Key('DeviceStatistics')));
    pages.addEvent(_pagesList);
  }

  void openFullStatus() {
    _pages.add(MaterialPage(
        child: FullStatusScreen($()), key: Key('FullStatusScreen')));
    pages.addEvent(_pagesList);
  }

  void openReportScreen() {
    _pages.add(MaterialPage(
        child: ServiceChatScreen($()), key: Key('ErrorReportScreen')));
    pages.addEvent(_pagesList);
  }

  void openOfflineHome() {
    _pages.add(
        MaterialPage(child: OfflineHome($(), $()), key: Key('OfflineHome')));
    pages.addEvent(_pagesList);
  }

  void didPop(Page page, dynamic result) {
    _pages.remove(page);
    _onPagePopped?.onPagePop(page.key);
    pages.addEvent(_pagesList);
  }
}

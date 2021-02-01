import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/main/fullStatusPage.dart';
import 'package:ble_app/src/screens/main/googleMapsPage.dart';
import 'package:ble_app/src/screens/main/shortStatusPage.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'RxObject.dart';

@lazySingleton
class InnerPageManager {
  // TODO: abstract this manager
  final _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  InnerPageManager() {
    pages.addEvent(_pagesList);
  }

  final pages = RxObject<List<Page>>();

  List<Page> get _pagesList => List.unmodifiable(_pages);

  final List<Page> _pages = [];

  void openShortStatus() {
    _pages.clear();
    _pages.add(
        ShortStatusPage(child: DeviceScreen($()), key: Key('ShortStatus')));
    pages.addEvent(_pagesList);
  }

  void openFullStatus() {
    _pages.clear();
    _pages.add(FullStatusPage(
        child: FullStatusScreen($()), key: Key('FullStatusScreen')));

    pages.addEvent(_pagesList);
  }

  void openMap() {
    _pages.clear();
    _pages.add(
      MaterialPage(
        child: MapPage($()),
        key: Key('MapPage'),
      ),
    );
    pages.addEvent(_pagesList);
  }

  void didPop(Page page, dynamic result) {
    _pages.remove(page);
    pages.addEvent(_pagesList);
  }
}

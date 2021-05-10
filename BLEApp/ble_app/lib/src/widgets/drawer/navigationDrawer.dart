import 'dart:ffi';

import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:flutter/material.dart';

typedef _LogOutListener = Future<void> Function();

class NavigationDrawer extends StatefulWidget {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final Stream<bool> _authorizedToAccessParameters;
  final _LogOutListener _onLogout;
  final bool isOffline;
  final bool isAnonymous;
  final VoidCallback onSwitchedToFull;
  final VoidCallback resumedToHome;

  const NavigationDrawer(this._prefsBloc, this._deviceBloc, this._onLogout,
      this._authorizedToAccessParameters,
      {this.isOffline,
      this.isAnonymous,
      this.onSwitchedToFull,
      this.resumedToHome});

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> with OnPagePopped {
  @override
  void initState() {
    super.initState();
    $<PageManager>().onPagePopped = this;
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            Divider(),
            _createDrawerItem(
                icon: Icons.settings_rounded,
                text: 'Settings',
                onTap: () => $<PageManager>().openSettings()),
            if (!widget.isAnonymous)
              _createDrawerItem(
                  icon: Icons.assessment,
                  text: 'Statistics',
                  onTap: () => $<PageManager>().openDeviceStatistics()),
            Divider(),
            _createDrawerItem(
                icon: Icons.battery_charging_full_sharp,
                text: 'Bat. status',
                onTap: () {
                  widget.onSwitchedToFull();
                  $<PageManager>().openFullStatus();
                }),
            /*
            if (!isOffline)
              StreamBuilder<bool>(
                  initialData: false,
                  stream: this._authorizedToAccessParameters,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active &&
                        snapshot.data == true) {
                      return _createDrawerItem(
                          icon: Icons.battery_charging_full_sharp,
                          text: 'Battery Settings',
                          onTap: () => $<PageManager>().openDeviceSettings());
                    } else
                      return Container();
                  }),

             */
            _createDrawerItem(
                icon: Icons.bluetooth_disabled,
                text: 'Disconnect',
                onTap: () =>
                    Navigator.of(context, rootNavigator: true).maybePop()),
            Divider(),
            _createDrawerItem(
                icon: Icons.logout,
                text: 'Logout',
                onTap: () => () => widget._onLogout().then((_) async {
                      widget._prefsBloc.clearUserPrefs();
                      widget._deviceBloc.disconnect();
                    })),
            Divider(),
            ListTile(
                title: const Text('Contact us',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'Europe_Ext')),
                onTap: () => $<PageManager>().openReportScreen()),
            ListTile(
              title: Text('Version 0.0.1. All rights reserved. '),
            ),
          ],
        ),
      );

  Widget _createHeader() => DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('path/to/header_background.png'))),
      // think of a real picture later on
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text("Bluetooth low energy app",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]));

  Widget _createDrawerItem(
          {IconData icon, String text, GestureTapCallback onTap}) =>
      ListTile(
        title: Row(
          children: <Widget>[
            Icon(icon),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontFamily: 'Europe_Ext'),
              ),
            )
          ],
        ),
        onTap: onTap,
      );

  @override
  void onPagePop(Key pageKey) {
    if (pageKey == const Key('FullStatusScreen')) {
      print('POPPED FULL STATUS');
      widget.resumedToHome();
    }
  }
}

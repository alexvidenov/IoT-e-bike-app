import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:flutter/material.dart';

typedef _LogOutListener = Future<void> Function();

class NavigationDrawer extends StatelessWidget {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final _LogOutListener _onLogout;

  const NavigationDrawer(this._prefsBloc, this._deviceBloc, this._onLogout);

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            Divider(),
            _createDrawerItem(
                icon: Icons.bluetooth,
                text: 'Connection Settings',
                onTap: () => $<PageManager>().openConnectionSettings()),
            _createDrawerItem(
                icon: Icons.devices,
                text: 'Battery Settings',
                onTap: () => $<PageManager>().openDeviceSettings()),
            _createDrawerItem(
                icon: Icons.assessment,
                text: 'Statistics',
                onTap: () => $<PageManager>().openDeviceStatistics()),
            Divider(),
            ListTile(
              title: const Text('Disconnect',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontFamily: 'Europe_Ext')),
              onTap: () =>
                  Navigator.of(context, rootNavigator: true).maybePop(),
            ),
            ListTile(
                title: const Text('Logout',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'Europe_Ext')),
                onTap: () => _onLogout().then((_) async {
                      _prefsBloc.clearUserPrefs();
                      _deviceBloc.disconnect();
                    })),
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
}

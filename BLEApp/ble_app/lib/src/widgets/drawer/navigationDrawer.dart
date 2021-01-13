import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/screens/Entrypoints/Root.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final AuthBloc _auth;

  const NavigationDrawer(this._prefsBloc, this._deviceBloc, this._auth);

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
                onTap: () => Navigator.of(context).pushNamed('/settings')),
            _createDrawerItem(
                icon: Icons.devices,
                text: 'Device Settings',
                onTap: () =>
                    Navigator.of(context).pushNamed('/batterySettings')),
            _createDrawerItem(
                icon: Icons.assessment, text: 'Statistics', onTap: () => {}),
            Divider(),
            ListTile(
                title: Text('Logout'),
                onTap: () async => await _auth.logout().then((_) async {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => RootPage(_auth)),
                          (route) => false);
                      _prefsBloc.clearPrefs();
                      await _deviceBloc.disconnect();
                    })),
            ListTile(
              title: Text('Version 0.0.1. All rights reserved. '),
              onTap: () {},
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
              child: Text(text),
            )
          ],
        ),
        onTap: onTap,
      );
}

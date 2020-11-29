import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  final SettingsBloc _prefsBloc = locator<SettingsBloc>();
  final DeviceBloc _deviceBloc = locator<DeviceBloc>();

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
                icon: Icons.devices, text: 'Device Settings', onTap: () => {}),
            _createDrawerItem(
                icon: Icons.assessment, text: 'Statistics', onTap: () => {}),
            Divider(),
            ListTile(
                title: Text('Logout'),
                onTap: () async =>
                    await locator<Auth>().signOut().then((_) async {
                      _prefsBloc.clearPrefs();
                      await _deviceBloc.disconnect();
                    })),
            ListTile(
              title: Text('Vertion 0.0.1. All rights reserved. '),
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

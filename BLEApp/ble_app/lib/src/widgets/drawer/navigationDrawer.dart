import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/Entrypoints/Root.dart';
import 'package:ble_app/src/screens/main/fullStatusPage.dart';
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
                onTap: () => Navigator.of(context).pushNamed('/settings')),
            _createDrawerItem(
                icon: Icons.devices,
                text: 'Device Settings',
                onTap: () =>
                    Navigator.of(context).pushNamed('/batterySettings')),
            _createDrawerItem(
                icon: Icons.app_settings_alt,
                text: 'Battery status',
                // change the icon somehow
                onTap: () => {}), //Navigator.of(context).push(
            //MaterialPageRoute(builder: (_) => FullStatusPage($())))),
            _createDrawerItem(
                icon: Icons.assessment, text: 'Statistics', onTap: () => {}),
            Divider(),
            ListTile(
              title: Text('Disconnect'),
              onTap: () {
                _deviceBloc.removeListener();
                _prefsBloc.clearPrefs();
                _deviceBloc.cancel();
                _deviceBloc.disconnect().then((_) => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/devices', (_) => false));
              },
            ),
            ListTile(
                title: Text('Logout'),
                onTap: () async => await _onLogout().then((_) async {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => RootPage($())),
                          // actually use popUntil route.isFirst
                          (_) => false);
                      _prefsBloc.clearPrefs();
                      _prefsBloc.deleteUserData();
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

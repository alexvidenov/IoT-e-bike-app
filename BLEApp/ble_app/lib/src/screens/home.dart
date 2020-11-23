import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/devicesListScreen.dart';
import 'package:ble_app/src/utils/Router.dart';
import 'package:ble_app/src/widgets/navigationDrawer.dart';

RouteObserver<PageRoute> routeObserver;

class HomeScreen extends StatelessWidget {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;

  const HomeScreen(this._prefsBloc, this._deviceBloc);

  _createObserver() {
    routeObserver = RouteObserver<PageRoute>();
  }

  @override
  Widget build(BuildContext context) {
    _createObserver();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white12,
        title: Text("Home"),
        actions: <Widget>[
          RaisedButton(
              color: Colors.lightBlueAccent,
              child: Text('BT Devices', style: TextStyle(color: Colors.white)),
              onPressed: () => _prefsBloc
                  .clearAllPrefs()
                  .then((_) => _deviceBloc.disconnect())
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DevicesListScreen(locator<DevicesBloc>()),
                      ),
                      (Route<dynamic> route) => false))),
        ],
      ),
      drawer: NavigationDrawer(),
      body: Navigator(
        initialRoute: '/',
        onGenerateRoute: Router.generateRoute,
        observers: [routeObserver],
      ),
    );
  }
}

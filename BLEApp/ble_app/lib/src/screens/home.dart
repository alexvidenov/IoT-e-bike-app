import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/navigationService.dart';
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

  final NavigationService _navigationService;

  final NavigationBloc _navigationBloc = locator<NavigationBloc>();

  HomeScreen(this._prefsBloc, this._deviceBloc)
      : this._navigationService = locator<NavigationService>();

  _instantiateObserver() => routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    _instantiateObserver();
    _navigationService.generateGlobalKey();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white12,
        title: StreamBuilder<CurrentPage>(
            stream: _navigationBloc.page,
            initialData: CurrentPage.Short,
            builder: (_, snapshot) {
              String _title;
              Function _onPressed;
              switch (snapshot.data) {
                case CurrentPage.Short:
                  _onPressed =
                      () => _navigationService.innerNavigateTo('/full');
                  _title = 'Short Status';
                  break;
                case CurrentPage.Full:
                  _onPressed = () => _navigationService.innerNavigateTo('/map');
                  _title = 'Full Status';
                  break;
                case CurrentPage.Map:
                  _onPressed = () => _navigationService.returnToFirstInner();
                  _title = 'Map';
                  break;
              }
              return RaisedButton(
                  color: Colors.lightBlueAccent,
                  onPressed: _onPressed,
                  child: Text(
                    _title,
                    style: TextStyle(color: Colors.white),
                  ));
            }),
        centerTitle: true,
        actions: <Widget>[
          RaisedButton(
            color: Colors.lightBlueAccent,
            child: Text('BT Devices', style: TextStyle(color: Colors.white)),
            onPressed: () => _prefsBloc
                .clearAllPrefs()
                .then((_) => _deviceBloc.disconnect())
                .then((value) => Navigator.push(
                      // think of implementing the popUntil
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DevicesListScreen(locator<DevicesBloc>()),
                      ),
                    )),
          )
        ],
      ),
      drawer: NavigationDrawer(),
      body: Navigator(
        initialRoute: '/',
        key: _navigationService.innerNavigatorKey,
        onGenerateRoute: Router.generateRouteSecondNavigator,
        observers: [routeObserver],
      ),
    );
  }
}

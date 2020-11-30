import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/utils/Router.dart' as R;
import 'package:ble_app/src/widgets/drawer/navigationDrawer.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class HomeScreen extends StatelessWidget {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final NavigationBloc _navigationBloc;

  const HomeScreen(this._prefsBloc, this._deviceBloc, this._navigationBloc);

  _instantiateObserver() => routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    _instantiateObserver();
    _navigationBloc.generateGlobalKey();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: StreamBuilder<CurrentPage>(
            stream: _navigationBloc.stream,
            initialData: CurrentPage.Short,
            builder: (_, snapshot) {
              String _title;
              Function _onPressed;
              switch (snapshot.data) {
                case CurrentPage.Short:
                  _onPressed = () => _navigationBloc.navigateTo('/full');
                  _title = 'Main status';
                  break;
                case CurrentPage.Full:
                  _onPressed = () => _navigationBloc.navigateTo('/map');
                  _title = 'Bat. status';
                  break;
                case CurrentPage.Map:
                  _onPressed = () => _navigationBloc.returnToFirstRoute();
                  _title = 'Location';
                  break;
              }
              return Container(
                decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 0.5,
                          spreadRadius: 0.5),
                    ]),
                child: RaisedButton(
                    color: Colors.black,
                    onPressed: _onPressed,
                    child: Text(_title,
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            letterSpacing: 2))),
              );
            }),
        centerTitle: true,
        actions: <Widget>[
          Container(
            child: RaisedButton(
                color: Colors.black,
                child: Text('Disconnect',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white, letterSpacing: 1.5)),
                onPressed: () {
                  _prefsBloc.clearPrefs();
                  _deviceBloc.disconnect().then((_) => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/devices', (_) => false));
                }),
            decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.white, blurRadius: 1, spreadRadius: 1),
                ]),
          )
        ],
      ),
      drawer: NavigationDrawer(),
      body: Navigator(
        initialRoute: '/',
        key: _navigationBloc.navigatorKey,
        onGenerateRoute: R.Router.generateRouteSecondNavigator,
        observers: [routeObserver],
      ),
    );
  }
}

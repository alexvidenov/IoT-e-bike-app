import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/utils/Router.dart' as router;
import 'package:ble_app/src/widgets/drawer/navigationDrawer.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class HomeScreen extends StatefulWidget {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final NavigationBloc _navigationBloc;

  const HomeScreen(this._prefsBloc, this._deviceBloc, this._navigationBloc);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _instantiateObserver() => routeObserver = RouteObserver<PageRoute>();

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Are you sure?',
                  style: TextStyle(fontFamily: 'Europe_Ext')),
              content: Text(
                  'Do you want to disconnect from the device and go back?',
                  style: TextStyle(fontFamily: 'Europe_Ext')),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
                FlatButton(
                    onPressed: () {
                      widget._deviceBloc.disconnect();
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes')),
              ],
            ) ??
            false);
  }

  @override
  Widget build(BuildContext context) {
    _instantiateObserver();
    widget._navigationBloc.generateGlobalKey();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: StreamBuilder<CurrentPage>(
              stream: widget._navigationBloc.stream,
              initialData: CurrentPage.Short,
              builder: (_, snapshot) {
                String _title;
                Function _onPressed;
                switch (snapshot.data) {
                  case CurrentPage.Short:
                    _onPressed =
                        () => widget._navigationBloc.navigateTo('/full');
                    _title = 'Main status';
                    break;
                  case CurrentPage.Full:
                    _onPressed =
                        () => widget._navigationBloc.navigateTo('/map');
                    _title = 'Bat. status';
                    break;
                  case CurrentPage.Map:
                    _onPressed =
                        () => widget._navigationBloc.returnToFirstRoute();
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
            IconButton(
                color: Colors.black,
                icon: Icon(
                  Icons.bluetooth_disabled_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  widget._prefsBloc.clearPrefs();
                  widget._deviceBloc.disconnect().then((_) =>
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/devices', (_) => false));
                }),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                        color: Colors.black,
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.white,
                        ),
                        onPressed: null),
                    Text(
                      'Location',
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        color: Colors.black,
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.white,
                        ),
                        onPressed: null),
                    Text(
                      'Bat. status',
                      style: TextStyle(color: Colors.white, fontSize: 23),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        drawer: NavigationDrawer($(), $(), $()),
        body: Navigator(
          initialRoute: '/',
          key: widget._navigationBloc.navigatorKey,
          onGenerateRoute: router.Router.generateRouteSecondNavigator,
          observers: [routeObserver],
        ),
      ),
    );
  }
}

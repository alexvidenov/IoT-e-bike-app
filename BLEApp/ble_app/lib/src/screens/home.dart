import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/listeners/disconnectedListener.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/utils/Router.dart' as router;
import 'package:ble_app/src/widgets/drawer/navigationDrawer.dart';

class HomeScreen extends StatefulWidget with Navigation {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final DeviceRepository _repository;

  const HomeScreen(this._prefsBloc, this._deviceBloc, this._repository);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with DisconnectedListener {
  bool _hasDisconnected = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _instantiateObserver() => routeObserver = RouteObserver<PageRoute>();

  Future<bool> _onWillPop() => showDialog(
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

  @override
  initState() {
    super.initState();
    widget._deviceBloc.setDisconnectedListener(this);
  }

  @override
  Widget build(BuildContext context) {
    _instantiateObserver();
    widget.navigationBloc.generateGlobalKey();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            appBar: AppBar(
                backgroundColor: Colors.black,
                title: StreamBuilder<CurrentPage>(
                    stream: widget.navigationBloc.stream,
                    initialData: CurrentPage.ShortStatus,
                    builder: (_, snapshot) {
                      String _title;
                      Function _onPressed;
                      switch (snapshot.data) {
                        case CurrentPage.ShortStatus:
                          _onPressed = () => widget.navigationBloc.to('/full');
                          _title = 'Main status';
                          break;
                        case CurrentPage.Controller:
                          _onPressed = () => widget.navigationBloc.to('/map');
                          _title = 'Bat. status';
                          break;
                        case CurrentPage.Map:
                          _onPressed =
                              () => widget.navigationBloc.returnToFirstRoute();
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
                                  spreadRadius: 0.4),
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
                centerTitle: false,
                actions: <Widget>[
                  Row(
                    children: [
                      Icon(Icons.bluetooth_disabled_outlined),
                      RaisedButton(
                        color: Colors.black,
                        onPressed: () {
                          widget._deviceBloc.removeListener();
                          widget._prefsBloc.clearUserPrefs();
                          widget._repository.cancel(); // fix that of course
                          widget._deviceBloc.disconnect().then((_) =>
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/devices', (_) => false));
                        },
                        child: Text( // TODO: StreamBuilder here
                          'Lock', // StreamBuilder here
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  )
                ],
                bottom: TabBar(
                  // TODO: add self as controller here, and update the index
                  labelColor: Colors.lightBlueAccent,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.black),
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        widget.navigationBloc.returnToFirstRoute();
                        break;
                      case 1:
                        widget.navigationBloc.to('/full');
                        break;
                      case 2:
                        widget.navigationBloc.to('/map');
                        break;
                    }
                  },
                  tabs: const [
                    Tab(
                      text: "Short Status",
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      text: "Full Status",
                      icon: Icon(Icons.dashboard),
                    ),
                    Tab(
                      text: "Map",
                      icon: Icon(Icons.zoom_out_map),
                    )
                  ],
                )),
            drawer: NavigationDrawer($(), $(), $<Auth>().signOut),
            body: Navigator(
              initialRoute: '/',
              key: widget.navigationBloc.navigatorKey,
              onGenerateRoute: router.Router.generateRouteSecondNavigator,
              observers: [routeObserver],
            ),
          ),
        ));
  }

  @override
  onDisconnected() {
    if (mounted) {
      widget._repository.cancel();
      _hasDisconnected = true;
      _scaffoldKey.currentState.showBottomSheet((_) => InkWell(
            child: Center(
              child: Text('Reconnect',
                  style: TextStyle(fontSize: 28, letterSpacing: 1.5)),
            ),
            onTap: () async => await widget._deviceBloc.connect(),
          ));
    }
  }

  authenticate(String password) => // TODO: remove that from here
      widget._repository.writeToCharacteristic('P$password\r');

  @override
  onReconnected() async {
    // FIXME: this fails
    if (_hasDisconnected && mounted) {
      // TODO: fix the h u g e mess here
      await Future.delayed(Duration(seconds: 3), () async {
        authenticate(widget._prefsBloc.password.value);
        await Future.delayed(
            Duration(milliseconds: 200), () => widget._repository.resume());
      }).then((_) => Navigator.of(context).pop());
    }
  }
}

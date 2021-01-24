import 'package:ble_app/src/blocs/OutputControlBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
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
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class HomeScreen extends StatefulWidget with Navigation {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final DeviceRepository _repository;
  final OutputControlBloc _controlBloc;

  const HomeScreen(
      this._prefsBloc, this._deviceBloc, this._repository, this._controlBloc);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasDisconnected = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _bottomSheetController;

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
    widget._controlBloc.create();
    widget._deviceBloc.connectionState.listen((event) {
      event.when(
          normalBTState: (state) {
            switch (state) {
              case PeripheralConnectionState.connected:
                this.onReconnected();
                break;
              case PeripheralConnectionState.disconnected:
                this.onDisconnected();
                break;
              default:
                break;
            }
          },
          bleException: (_) => {});
      print(event);
    });
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
                  StreamBuilder<OutputsState>(
                    stream: widget._controlBloc.stream,
                    initialData: OutputsState.On,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        Text text = snapshot.data == OutputsState.On
                            ? Text('Off',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20))
                            : Text('On',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20));
                        Icon icon = snapshot.data == OutputsState.On
                            ? Icon(Icons.lock)
                            : Icon(Icons.lock_open);
                        final function = (func) async {
                          widget._repository.cancel();
                          await Future.delayed(
                              Duration(milliseconds: 150), () => func());
                          Future.delayed(Duration(milliseconds: 80),
                              () => widget._repository.resume());
                        };
                        final funcToPass = snapshot.data == OutputsState.On
                            ? () => widget._controlBloc.off()
                            : () => widget._controlBloc.on();
                        return Row(
                          children: <Widget>[
                            icon,
                            RaisedButton(
                              color: Colors.deepPurple,
                              onPressed: () => function(funcToPass),
                              child: text,
                            ),
                          ],
                        );
                      } else
                        return Container();
                    },
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

  //@override
  onDisconnected() {
    if (mounted) {
      widget._repository.cancel();
      _hasDisconnected = true;
      _bottomSheetController =
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

  //@override
  onReconnected() async {
    // FIXME: this fails
    if (_hasDisconnected && mounted) {
      print('RECONNECTED');
      _bottomSheetController?.close();
      String password = widget._prefsBloc.password.value;
      await Future.delayed(Duration(milliseconds: 1000), () async {
        authenticate(password);
        print('Password is $password');
        await Future.delayed(
            Duration(milliseconds: 100), () => widget._repository.resume());
      });
    }
  }

  //@override
  onReadyToAuthenticate() {
    print('READY TO AUTTH');
  }
}

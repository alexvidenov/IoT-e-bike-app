import 'dart:async';

import 'package:ble_app/src/blocs/InnerPageManager.dart';
import 'package:ble_app/src/blocs/OutputControlBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/sealedStates/deviceConnectionState.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/utils/StreamListener.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/widgets/drawer/navigationDrawer.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatefulWidget with Navigation {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final DeviceRepository _repository;
  final OutputControlBloc _controlBloc;
  final InnerPageManager _pageManager;

  HomeScreen(this._prefsBloc, this._deviceBloc, this._repository,
      this._controlBloc, this._pageManager);

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
                    widget._prefsBloc.clearUserPrefs();
                    widget._deviceBloc.cancel();
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
    $<InnerPageManager>().openShortStatus();
  }

  function(func) async {
    widget._repository.cancel();
    await Future.delayed(Duration(milliseconds: 150), () => func());
    Future.delayed(
        Duration(milliseconds: 80), () => widget._repository.resume());
  }

  @override
  Widget build(BuildContext context) {
    _instantiateObserver();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: false,
                actions: <Widget>[
                  StreamBuilder<OutputsState>(
                    stream: widget._controlBloc.stream,
                    initialData: OutputsState.Off,
                    builder: (_, snapshot) {
                      Text text = snapshot.data == OutputsState.On
                          ? Text('Locked',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1.3))
                          : Text('Unlocked',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1.3));
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
                      return OutlinedButton.icon(
                        icon: icon,
                        label: text,
                        onPressed: () => function(funcToPass),
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              width: 5.0,
                              color: snapshot.data == OutputsState.Off
                                  ? Colors.green
                                  : Colors.redAccent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              drawer: NavigationDrawer($(), $(), $<Auth>().signOut),
              body: StreamListener<DeviceConnectionState>(
                  stream: widget._deviceBloc.connectionState,
                  onData: (state) {
                    state.when(
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
                  },
                  child: StreamBuilder<List<Page>>(
                    stream: widget._pageManager.pages.stream,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        print('BUILDIGN INNER NAVIGATOR WITH PAGES =>');
                        print(snapshot.data);
                        return Navigator(
                            key: widget._pageManager.navigatorKey,
                            pages: snapshot.data,
                            onPopPage: (route, result) =>
                                _onPopPage(route, result, widget._pageManager));
                      } else
                        return Container();
                    },
                  )),
              bottomNavigationBar: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: -10,
                            blurRadius: 60,
                            color: Colors.black.withOpacity(.4),
                            offset: Offset(0, 25))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 3.0, vertical: 3),
                    child: StreamBuilder<CurrentPage>(
                      stream: widget.navigationBloc.stream,
                      initialData: CurrentPage.ShortStatus,
                      builder: (_, snapshot) {
                        int _index;
                        switch (snapshot.data) {
                          case CurrentPage.ShortStatus:
                            _index = 0;
                            break;
                          case CurrentPage.FullStatus:
                            _index = 1;
                            break;
                          case CurrentPage.Map:
                            _index = 2;
                            break;
                        }
                        return GNav(
                            gap: 8,
                            activeColor: Colors.white30,
                            iconSize: 24,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeOutExpo,
                            tabBackgroundColor: Colors.lightBlue,
                            textStyle: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                            tabs: [
                              GButton(
                                gap: 8,
                                icon: Icons.home,
                                iconActiveColor: Colors.redAccent,
                                iconColor: Colors.black,
                                textColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 5),
                                backgroundColor: Colors.greenAccent,
                                text: 'Home',
                              ),
                              GButton(
                                  gap: 8,
                                  icon: Icons.battery_charging_full_sharp,
                                  text: 'Bat. status',
                                  iconActiveColor: Colors.redAccent,
                                  iconColor: Colors.black,
                                  textColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 5),
                                  backgroundColor: Colors.lightBlue),
                              GButton(
                                gap: 8,
                                icon: Icons.location_on_sharp,
                                iconActiveColor: Colors.redAccent,
                                iconColor: Colors.black,
                                textColor: Colors.black,
                                backgroundColor: Colors.yellow,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 5),
                                text: 'Location',
                              ),
                            ],
                            selectedIndex: _index,
                            onTabChange: (index) {
                              switch (index) {
                                case 0:
                                  $<InnerPageManager>().openShortStatus();
                                  break;
                                case 1:
                                  $<InnerPageManager>().openFullStatus();
                                  break;
                                case 2:
                                  $<InnerPageManager>().openMap();
                                  break;
                              }
                            });
                      },
                    ),
                  ),
                ),
              )),
        ));
  }

  bool _onPopPage(
      Route<dynamic> route, dynamic result, InnerPageManager pageManager) {
    print('POPPING =>');
    print(route.settings);
    pageManager.didPop(route.settings, result);
    return route.didPop(result);
  }

  onDisconnected() {
    if (mounted) {
      print('ONDISCONNECTED');
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

  onReconnected() async {
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
}

import 'dart:async';

import 'package:ble_app/src/blocs/OutputControlBloc.dart';
import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/screens/main/fullStatusPage.dart';
import 'package:ble_app/src/screens/main/googleMapsPage.dart';
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

import '../../main.dart';
import 'main/shortStatusPage.dart';

class VisibleRouteNotification extends Notification {
  final CurrentPage currentPage;

  const VisibleRouteNotification(this.currentPage);
}

class HomeScreen extends StatefulWidget {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final DeviceRepository _repository;
  final OutputControlBloc _controlBloc;

  // TODO: actually use InheritedWidget here to pass this very instances to the other pages
  final ShortStatusBloc _shortStatusBloc;
  final FullStatusBloc _fullStatusBloc;
  final LocationBloc _locationBloc;

  const HomeScreen(
      this._prefsBloc,
      this._deviceBloc,
      this._repository,
      this._controlBloc,
      this._shortStatusBloc,
      this._fullStatusBloc,
      this._locationBloc);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _hasDisconnected = false;

  bool _isDisconnectManual = false;

  PersistentBottomSheetController _bottomSheetController;

  List<Widget> get _pages => <Widget>[
        DeviceScreen(widget._shortStatusBloc, widget._locationBloc),
        FullStatusScreen(widget._fullStatusBloc),
        MapPage(widget._locationBloc),
      ];

  int _currentTab = 0;

  final _pageController = PageController();

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: _pages,
    );
  }

  void _handlePageChange(int index) {
    print('INDEX NOW IS $index');
    switch (index) {
      case 0:
        widget._fullStatusBloc.pause();
        widget._shortStatusBloc.create();
        widget._shortStatusBloc.resume();
        break;
      case 1:
        widget._shortStatusBloc.pause();
        widget._fullStatusBloc.create();
        widget._fullStatusBloc.resume();
        break;
      case 2:
        widget._fullStatusBloc.pause();
        widget._shortStatusBloc.create();
        widget._shortStatusBloc.resume();
        break;
    }
  }

  void pageChanged(int index) {
    _handlePageChange(index);
    setState(() => _currentTab = index);
  }

  void bottomTapped(int index) {
    _handlePageChange(index);
    setState(() {
      _currentTab = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

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
                    _isDisconnectManual = true;
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
    widget._fullStatusBloc.initMotoTimers();
    widget._shortStatusBloc
        .create(); // Necessary cuz we don't get the PageView callback at first.
    widget._shortStatusBloc.resume();
    widget._locationBloc.create();
  }

  Future<void> outputsControlCompletion(func) async {
    widget._repository.cancel();
    await Future.delayed(Duration(milliseconds: 150), () => func());
    Future.delayed(
        Duration(milliseconds: 80), () => widget._repository.resume());
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
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
                      return OutlinedButton(
                        child: text,
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
                child: _buildPageView(),
              ),
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
                    child: GNav(
                        gap: 8,
                        activeColor: Colors.white30,
                        iconSize: 24,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                        selectedIndex: _currentTab,
                        onTabChange: (index) {
                          bottomTapped(index);
                        }),
                  ),
                ),
              ),
            )),
      );

  void onDisconnected() {
    if (mounted && !_isDisconnectManual) {
      widget._repository.cancel();
      widget._fullStatusBloc.pauseMotoTimers();
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

  void authenticate(String password) =>
      widget._repository.writeToCharacteristic('P$password\r');

  void onReconnected() async {
    if (_hasDisconnected && mounted) {
      _bottomSheetController?.close();
      String password = widget._prefsBloc.password.value;
      await Future.delayed(Duration(milliseconds: 1000), () async {
        authenticate(password);
        await Future.delayed(
            Duration(milliseconds: 100), () => widget._repository.resume());
      });
    }
  }

  @override
  void dispose() {
    logger.wtf('DISPOSING HOME');
    widget._shortStatusBloc.dispose();
    widget._fullStatusBloc.dispose();
    widget._locationBloc.dispose();
    super.dispose();
  }
}

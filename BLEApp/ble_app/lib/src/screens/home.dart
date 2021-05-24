import 'dart:async';

import 'package:ble_app/src/blocs/IsSuperBloc.dart';
import 'package:ble_app/src/blocs/OutputControlBloc.dart';
import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/blocs/status/shortStatusBloc.dart';
import 'package:ble_app/src/blocs/location/locationBloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/screens/base/PageViewWidget.dart';
import 'package:ble_app/src/screens/main/googleMaps/googleMapsPage.dart';
import 'package:ble_app/src/sealedStates/deviceConnectionState.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/utils/StreamListener.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/prefs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/widgets/drawer/navigationDrawer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../main.dart';
import 'main/status/shortStatusPage.dart';

class VisibleRouteNotification extends Notification {
  final CurrentPage currentPage;

  const VisibleRouteNotification(this.currentPage);
}

class Home extends PageViewWidget {
  final SettingsBloc _prefsBloc;
  final DeviceBloc _deviceBloc;
  final DeviceRepository _repository;
  final OutputControlBloc _controlBloc;

  // TODO: actually use InheritedWidget here to pass this very instances to the other pages
  final ShortStatusBloc _shortStatusBloc;
  final LocationBloc _locationBloc;

  final IsSuperBloc _navDrawerBloc;

  const Home(
    this._prefsBloc,
    this._deviceBloc,
    this._repository,
    this._controlBloc,
    this._shortStatusBloc,
    this._locationBloc,
    this._navDrawerBloc,
  );

  @override
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      centerTitle: false,
      actions: <Widget>[
        StreamBuilder<OutputsState>(
          stream: _controlBloc.stream,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final Text text = snapshot.data == OutputsState.On
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
                _repository.cancel();
                await Future.delayed(Duration(milliseconds: 150), () => func());
                Future.delayed(
                    Duration(milliseconds: 80), () => _repository.resume());
              };
              final funcToPass = snapshot.data == OutputsState.On
                  ? () => _controlBloc.off()
                  : () => _controlBloc.on();
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
            } else
              return Container(
                child: Center(
                  child: Text('Loading state'),
                ),
              );
          },
        )
      ],
    );
  }

  @override
  Widget buildDrawer(BuildContext context) => NavigationDrawer(
        $(),
        $(),
        $<Auth>().signOut,
        isOffline: false,
        isAnonymous: _navDrawerBloc.isAnonymous,
        onSwitchedToFull: _shortStatusBloc.pause,
        resumedToHome: _shortStatusBloc.resume,
      );

  @override
  List<GButton> buildTabs() => [
        GButton(
          gap: 8,
          icon: Icons.home,
          iconActiveColor: Colors.redAccent,
          iconColor: Colors.black,
          textColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          backgroundColor: Colors.greenAccent,
          text: 'Home',
        ),
        GButton(
          gap: 8,
          icon: Icons.location_on_sharp,
          iconActiveColor: Colors.redAccent,
          iconColor: Colors.black,
          textColor: Colors.black,
          backgroundColor: Colors.yellow,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          text: 'Location',
        ),
      ];

  @override
  List<Widget> get pages => [
        DeviceScreen(_shortStatusBloc, _locationBloc),
        MapPage(
          _locationBloc,
          false,
        ),
      ];

  @override
  PageViewWidgetState<PageViewWidget> createState() => _HomeState();
}

class _HomeState extends PageViewWidgetState<Home>
    with OnShouldLockPageViewScroll {
  // THIS MIXIN SHOULD BE DELEGATED THROUGH THE LOCATION BLOC SOMEHOW. (IN INIT STATE HERE, SETUP LISTENER)
  bool _hasDisconnected = false;

  bool _isDisconnectManual = false;

  PersistentBottomSheetController _bottomSheetController;

  Future<void> outputsControlCompletion(func) async {
    widget._repository.cancel();
    await Future.delayed(Duration(milliseconds: 150), () => func());
    Future.delayed(
        Duration(milliseconds: 80), () => widget._repository.resume());
  }

  void onDisconnected() {
    if (mounted && !_isDisconnectManual) {
      widget._repository.cancel();
      //widget._fullStatusBloc.pauseMotoTimers();
      _hasDisconnected = true;
      _bottomSheetController =
          scaffoldKey.currentState.showBottomSheet((_) => InkWell(
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
    if (_hasDisconnected) {
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
  StreamListener listener<T>(Widget child) {
    return StreamListener<DeviceConnectionState>(
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
            bleException: (_) => print('ble exc: ${_}'));
      },
      child: child,
    );
  }

  @override
  Future<bool> onWillPop(context) => showDialog(
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
  void shouldScroll(bool shouldScroll) {
    if (mounted) {
      refreshWithShouldScroll(shouldScroll: shouldScroll);
    }
  }

  @override
  void initState() {
    super.initState();
    widget._controlBloc.create();
    widget._shortStatusBloc
        .create(); // Necessary cuz we don't get the PageView callback at first.
    widget._shortStatusBloc.resume();
    widget._locationBloc.create();
    widget._locationBloc.onShouldLockPageViewScroll = this;
    _setOrientation();
  }

  void _setOrientation() => SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

  @override
  void dispose() {
    logger.wtf('DISPOSING HOME');
    widget._shortStatusBloc.dispose();
    widget._locationBloc.dispose();
    super.dispose();
  }
}

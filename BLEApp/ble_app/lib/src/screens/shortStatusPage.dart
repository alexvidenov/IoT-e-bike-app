import 'dart:async';
import 'package:ble_app/src/BluetoothUtils.dart';
import 'package:ble_app/src/blocs/btConnectionBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isDisposed = false;

  @override
  bool get wantKeepAlive => true;

  _cancel() {
    if (_isDisposed == false) {
      GetIt.I<ShortStatusBloc>().cancel();
    }
  }

  _resume() {
    if (_isDisposed == true) {
      GetIt.I<ShortStatusBloc>().resume();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    GetIt.I<ConnectionBloc>().connect();
  }

  _pop() {
    Navigator.of(context).pop(true);
  }

  _onVisibilityHandler(VisibilityInfo info) {
    var visiblePercentage = info.visibleFraction * 100;
    if (visiblePercentage < 1) {
      // widget is disposed
      _cancel();
      _isDisposed = true;
    } else if (visiblePercentage > 1 && _isDisposed == true) {
      _resume();
      _isDisposed = false;
    }
  }

  Future<bool> _onWillPop() {
    final bloc = GetIt.I<ConnectionBloc>();
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Are you sure?',
                  style: TextStyle(fontFamily: 'Europe_Ext')),
              content: Text('Do you want to disconnect device and go back?',
                  style: TextStyle(fontFamily: 'Europe_Ext')),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
                FlatButton(
                    onPressed: () {
                      bloc.disconnect();
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes')),
              ],
            ) ??
            false);
  }

  @override
  void dispose() {
    super.dispose();
    GetIt.I<ConnectionBloc>().dispose();
    GetIt.I<ShortStatusBloc>().dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var connectionBloc = GetIt.I<ConnectionBloc>();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: VisibilityDetector(
        key: Key("ShortStatusPage"),
        onVisibilityChanged: (VisibilityInfo info) =>
            _onVisibilityHandler(info),
        child: Scaffold(
          body: Container(
            child: StreamBuilder<ConnectionEvent>(
              stream: connectionBloc.bluetoothState, // the connection stream
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  switch (snapshot.data) {
                    case ConnectionEvent.Connected:
                      //return TestWidget();
                      return Column(
                        children: <Widget>[
                          ProgressRows(),
                        ],
                      );
                    case ConnectionEvent.Connecting:
                      return Center(child: CircularProgressIndicator());
                    case ConnectionEvent.FailedToConnect:
                      _pop();
                  }
                  //return Center(child: CircularProgressIndicator());
                } else
                  return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}

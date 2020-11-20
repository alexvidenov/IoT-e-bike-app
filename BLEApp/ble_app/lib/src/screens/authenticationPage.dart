import 'dart:async';

import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/btConnectionBloc.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get_it/get_it.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _writeController = TextEditingController();

  StreamSubscription<BluetoothDeviceState> streamSubscriptionState;
  StreamSubscription<bool> streamSubscriptionAuth;

  @override
  void initState() {
    super.initState();
    _listenToConnectBloc();
    _listenToAuthBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    GetIt.I<ConnectionBloc>().connect();
  }

  _listenToConnectBloc() {
    streamSubscriptionState = GetIt.I<ConnectionBloc>().stream.listen((event) {
      if (event == BluetoothDeviceState.connected) {
        _presentDialog(context);
      }
    });
  }

  _listenToAuthBloc() {
    streamSubscriptionAuth = GetIt.I<BluetoothAuthBloc>().stream.listen((event) {
      if (event == true) {
        GetIt.I<BluetoothAuthBloc>().dispose();
        GetIt.I<ConnectionBloc>().dispose();
        streamSubscriptionState.cancel();
        streamSubscriptionAuth.cancel();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    });
  }

  Future<void> _presentDialog(BuildContext widgetContext) async {
    await showDialog(
      context: widgetContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter your password"),
          content: TextField(
            controller: _writeController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Send"),
              onPressed: () => GetIt.I<BluetoothAuthBloc>()
                  .authenticate(_writeController.value.text),
            ),
          ],
        );
      },
    );
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          child: StreamBuilder<BluetoothDeviceState>(
            stream: GetIt.I<ConnectionBloc>().stream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                switch (snapshot.data) {
                  case BluetoothDeviceState.connected:
                    return Container();
                  case BluetoothDeviceState.connecting:
                    return Center(child: CircularProgressIndicator());
                  case BluetoothDeviceState.disconnected:
                    return Center(
                      child: Text("Disconnected"),
                    );
                  case BluetoothDeviceState.disconnecting:
                    break;
                }
              } else
                return Container();
            },
          ),
        ),
      ),
    );
  }
}

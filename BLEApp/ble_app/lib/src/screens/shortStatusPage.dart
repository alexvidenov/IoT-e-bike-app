import 'dart:async';
import 'package:ble_app/src/BluetoothUtils.dart';
import 'package:ble_app/src/blocs/btConnectionBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ConnectionBloc>(context, listen: false)
        .connect(); // REMOVE THISFUCKING HTING FROM HEREM ITS AUTISTIC
  }

  _pop() {
    Navigator.of(context).pop(true);
  }

  Future<bool> _onWillPop() {
    final bloc = Provider.of<ConnectionBloc>(context, listen: false);
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to disconnect device and go back?'),
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
    Provider.of<ConnectionBloc>(context).dispose();
    Provider.of<ShortStatusBloc>(context).dispose();
  }

  @override
  Widget build(BuildContext context) {
    var connectionBloc = Provider.of<ConnectionBloc>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
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
    );
  }
}

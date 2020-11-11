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
    Provider.of<ConnectionBloc>(context, listen: false).connect();
  }

  _Pop() {
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
    Provider.of<ConnectionBloc>(context).repository.dispose();
    Provider.of<ShortStatusBloc>(context).dispose();
    Provider.of<ShortStatusBloc>(context).repository.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var connectionBloc = Provider.of<ConnectionBloc>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Device Screen'),
        ),
        body: Container(
          child: StreamBuilder<ConnectionEvent>(
            stream: connectionBloc.bluetoothState, // the connection stream
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                switch (snapshot.data) {
                  case ConnectionEvent.Connected:
                    return TestWidget();
                  case ConnectionEvent.Connecting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionEvent.FailedToConnect:
                    _Pop();
                }
                return Center(child: CircularProgressIndicator());
              } else
                return Container();
              // this is snapshot of a connectionEvent
            },
          ),
          /*
          child: BlocBuilder<ConnectionBloc, ConnectionEvent>(
            builder: (_, state) {
              switch (state) {
                case ConnectionEvent.Connected:
                  //return TestWidget();
                  return Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              TopBar(),
                              Positioned(
                                top: 20.0,
                                left: 0.0,
                                right: 0.0,
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          'Parameters',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0,
                                              color: Colors.white,
                                              letterSpacing: 1.2),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                          onPressed:
                                              () {}, // later on this will move to the previous page
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            'Ble app',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                                color: Colors.white,
                                                letterSpacing: 1.2),
                                          ),
                                          Text(
                                            'Short status',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                                color: Colors.white,
                                                letterSpacing: 1.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          'Full status page',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0,
                                              color: Colors.white,
                                              letterSpacing: 1.2),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                          onPressed:
                                              () {}, // later on this will move to the next page
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ), // here ends the top nav
                          SleekCircularSlider(
                            appearance: appearance01,
                            min: 0.00,
                            max: 80.00,
                            initialValue:
                                50, // will fetch data from gps eventually
                          ),
                          CurrentRow(),
                          //Divider(),
                          // uncomment to test communication
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: ProgressRows(), // this will be the Consumer
                          ),
                          // here goes the horizontal progress bar (or two of them)
                        ],
                      ),
                    ],
                  );
                case ConnectionEvent.Connecting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionEvent.FailedToConnect:
                  _Pop();
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          */
        ),
      ),
    );
  }
}

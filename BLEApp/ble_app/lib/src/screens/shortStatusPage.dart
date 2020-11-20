import 'package:ble_app/src/blocs/btConnectionBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get_it/get_it.dart';

import 'abstractVisibleWidget.dart';

class DeviceScreen extends VisibleWidget {
  @override
  Widget buildWidget() {
    var connectionBloc = GetIt.I<ConnectionBloc>();
    return Scaffold(
      body: Container(
        child: StreamBuilder<BluetoothDeviceState>(
          stream: connectionBloc.stream, // the connection stream
          initialData: BluetoothDeviceState.disconnected,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  //return TestWidget();
                  return Column(
                    children: <Widget>[
                      ProgressRows(),
                    ],
                  );
                case BluetoothDeviceState.connecting:
                  return Center(child: CircularProgressIndicator());
                case BluetoothDeviceState.disconnected:
                  return Center(
                    child: Text("Disconnected"),
                  );
                case BluetoothDeviceState.disconnecting:
                  break;
                //_pop();
              }
            } else
              return Container();
          },
        ),
      ),
    );
  }

  @override
  void onPause() {
    GetIt.I<ShortStatusBloc>().cancel();
  }

  @override
  void onResume() {
    GetIt.I<ShortStatusBloc>().resume();
  }

  @override
  void onCreate() {
    GetIt.I<ConnectionBloc>().connect();
  }
}

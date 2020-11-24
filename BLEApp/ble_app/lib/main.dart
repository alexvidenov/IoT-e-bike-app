import 'dart:async';

import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/entryEndpointBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/screens/Entrypoints/AuthEntrypoint.dart';
import 'package:ble_app/src/screens/Entrypoints/DevicesEntrypoint.dart';
import 'package:ble_app/src/screens/Entrypoints/Root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setUpDependencies();
  runApp(RootPage());
}

class BleApp extends StatefulWidget {
  @override
  _BleAppState createState() => _BleAppState();
}

class _BleAppState extends State<BleApp> {
  final DevicesBloc devicesBloc = locator<DevicesBloc>();
  final EntryEndpointBloc _endpointBloc = locator<EntryEndpointBloc>();

  StreamSubscription _devicePickedSubscription;

  void _onPause() => _devicePickedSubscription.cancel();

  _listen() {
    _devicePickedSubscription = devicesBloc.pickedDevice.listen((_) {
      this._onPause();
      devicesBloc.pause();
      _endpointBloc.setEndpoint(Endpoint.AuthScreen);
    });
  }

  @override
  void initState() {
    super.initState();
    String _deviceId = locator<SettingsBloc>().getOptionalDeviceId();
    if (_deviceId != 'empty') {
      BleDevice device =
          BleDevice(peripheral: BleManager().createUnsafePeripheral(_deviceId));
      _listen();
      devicesBloc.init();
      devicesBloc.create();
      devicesBloc.addEvent(device);
    } else {
      _endpointBloc.setEndpoint(Endpoint.DevicesScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _endpointBloc.endpointStream,
      initialData: Endpoint.Unknown,
      builder: (_, snapshot) {
        switch (snapshot.data) {
          case Endpoint.Unknown:
            return Center(child: CircularProgressIndicator());
          case Endpoint.AuthScreen:
            return AuthEntrypoint();
          case Endpoint.DevicesScreen:
            return DevicesEntrypoint();
        }
        return Container();
      },
    );
  }
}

/*
// With auto password:
AuthEntrypoint:
devicesBloc.pickedDevice.listen()
devicesBloc.init();
devicesBloc.create();
devicesBloc.addEvent(device);
_devicePickedSubscription.cancel()
devicesBloc.pause();

authBloc.create();
_deviceBloc.init();
_deviceBloc.connect();
authBloc.resume();
_listenToAuthBloc(context);
_listenToConnectBloc(context);
_deviceBloc.deviceReady.listen()  //
 _deviceReadySubscription.cancel();
_authBloc.authenticate(_settingsBloc.getPassword());
_authBloc.pause()
 _streamSubscriptionState.cancel();
_streamSubscriptionAuth.cancel();
 Navigator.of(context).pushNamed(
'/home'); // 
*/

/*
Manual:
_devicesBloc.create();
_devicesBloc.init();
_devicesBloc.pickedDevice.listen()
 devicesBloc.addEvent(bleDevice) - onTap;
_pickedDevicesSubscription.cancel();
_devicesBloc.pause();

Navigator.of(context)
.pushNamed('/auth'); 
authBloc.create();
_deviceBloc.init();
_deviceBloc.connect();
authBloc.resume();
_listenToAuthBloc(context);
_listenToConnectBloc(context);
_presentDialog(context);
_authBloc.authenticate(_writeController.value.text);
_authBloc.pause();
 _streamSubscriptionState.cancel();
_streamSubscriptionAuth.cancel();
 Navigator.of(context).pushNamed(
              '/home');

*/

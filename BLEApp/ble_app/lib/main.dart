import 'dart:convert';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:ble_app/src/blocs/entryEndpointBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/Entrypoints/AuthEntrypoint.dart';
import 'package:ble_app/src/screens/Entrypoints/DevicesEntrypoint.dart';
import 'package:ble_app/src/screens/Entrypoints/Root.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Storage.dart';
import 'package:ble_app/src/utils/PrefsKeys.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setUpDependencies();
  await AndroidAlarmManager
      .initialize(); // TODO: configure the iOS part as well
  await AndroidAlarmManager.periodic(Duration(minutes: 1), 0, uploadCallback,
      rescheduleOnReboot: true);
  runApp(RootPage());
}

void uploadCallback() async {
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = prefs.get(PrefsKeys.USER_DATA);
  if (jsonString != null) {
    Storage(uid: Auth().getCurrentUserId()).upload(jsonDecode(jsonString));
    prefs.remove(PrefsKeys.USER_DATA);
  }
}

class BleApp extends StatefulWidget {
  final EntryEndpointBloc _endpointBloc;

  const BleApp(this._endpointBloc);

  @override
  _BleAppState createState() => _BleAppState();
}

class _BleAppState extends State<BleApp> {
  @override
  void initState() {
    super.initState();
    widget._endpointBloc.create();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget._endpointBloc.stream,
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

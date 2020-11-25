import 'dart:async';
import 'dart:convert';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/entryEndpointBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/screens/Entrypoints/AuthEntrypoint.dart';
import 'package:ble_app/src/screens/Entrypoints/DevicesEntrypoint.dart';
import 'package:ble_app/src/screens/Entrypoints/Root.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Storage.dart';
import 'package:ble_app/src/utils/PrefsKeys.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
void callBackDispatcher() => Workmanager.executeTask((taskName, __) {
      switch (taskName) {
        case 'writeToStorage':
          print('interesting');
          return Future.value(true);
        case 'task':
          final settings = locator<SettingsBloc>();
          String data = settings.getUserData();
          if (data != 'empty') {
            Storage(uid: locator<Auth>().getCurrentUserId())
                .upload(jsonDecode(data));
            settings.deleteUserData();
          }
        //return Future.value(true);
        // SHOULD DELETE THE DATA EVERY TIME IT IS UPLOADED TO STORAGE. WRITE FOR 24 HOURS - UPLOAD, THEN DELETE, THEN WAIT 24 HOURS AGAIN.
      }
      return Future.value(true);
    });
    */

//const writeToStorageTaskKey = 'writeToStorage';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setUpDependencies();
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(Duration(minutes: 1), 0, uploadCallback,
      rescheduleOnReboot: true);
  //await Workmanager.initialize(callBackDispatcher, isInDebugMode: true);
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
  /*
  StorageReference root = FirebaseStorage.instance.ref();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseAuth auth = FirebaseAuth.instance;

  String uid = auth.currentUser?.uid;

  String data = prefs.get('user_data');

  if (data != null) {
    Map<String, dynamic> json = jsonDecode(data);
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json);
    List<int> bytes = utf8.encode(jsonString);
    String base64str = base64.encode(bytes);
    Uint8List uploadData = base64.decode(base64str);

    DateTime dateTime = DateTime.now();

    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();

    String fileName = year + month + day + '.json';

    StorageReference fireRef = root.child(
        '/users/$uid/$fileName'); // later on use the list API to list every file under /users/$uid

    fireRef.putData(uploadData);

    prefs.remove('user_data');
  }
  */
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
    /*
    Workmanager.registerOneOffTask('2', 'writeToStorage',
        initialDelay: Duration(seconds: 10));
    Workmanager.registerOneOffTask('1', 'task',
        initialDelay: Duration(seconds: 15)); // works BOOOOOY
        */
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

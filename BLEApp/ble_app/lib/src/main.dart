import 'dart:convert';
import 'dart:io';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:ble_app/src/blocs/entryEndpointBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/screens/Entrypoints/AuthEntrypoint.dart';
import 'package:ble_app/src/screens/Entrypoints/DevicesEntrypoint.dart';
import 'package:ble_app/src/screens/Entrypoints/Root.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/CloudMessaging.dart';
import 'package:ble_app/src/services/Storage.dart';
import 'package:ble_app/src/utils/PrefsKeys.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies();
  BleManager().createClient(restoreStateIdentifier: "com.parakatowski.ble_app");
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(Duration(minutes: 2), 0, uploadCallback,
        exact: true, rescheduleOnReboot: true);
  } else if (Platform.isIOS) {
    // TODO: configure the iOS part as well
  }
  $<CloudMessaging>().init();
  $.isReady<LocalDatabase>().then((_) => runApp(RootPage($())));
}

Future<void> uploadCallback() async {
  await Firebase.initializeApp();
  print('I AM IN THE ISOLAAAAATEEEEEEEEEEEEEEEE');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String jsonString = prefs.get(PrefsKeys.USER_DATA);
  if (jsonString != null) {
    print('NOT NULL DATA');
    print('User Id: ' + Auth().getCurrentUserId());
    await prefs.remove(PrefsKeys.USER_DATA);
    await Storage(uid: Auth().getCurrentUserId())
        .upload(jsonDecode(jsonString))
        .then((_) => print('UPLOADING DONE'));
  }
}

class BleApp extends RouteAwareWidget<EntryEndpointBloc> {
  const BleApp(EntryEndpointBloc endpointBloc) : super(bloc: endpointBloc);

  @override
  Widget buildWidget(BuildContext context) => StreamBuilder(
        stream: super.bloc.stream,
        initialData: Endpoint.Unknown,
        builder: (_, snapshot) {
          switch (snapshot.data) {
            case Endpoint.Unknown:
              return Center(child: CircularProgressIndicator());
            case Endpoint.AuthScreen:
              return AuthEntryPoint();
            case Endpoint.DevicesScreen:
              return DevicesEntryPoint();
          }
          return Container();
        },
      );
}

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
import 'package:ble_app/src/services/Storage.dart';
import 'package:ble_app/src/utils/PrefsKeys.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies();
  BleManager().createClient(restoreStateIdentifier: "com.parakatowski.ble_app");
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(Duration(minutes: 1), 0, uploadCallback,
        exact: true, rescheduleOnReboot: true);
  } else if (Platform.isIOS) {
    // TODO: configure the iOS part as well
  }
  $.isReady<LocalDatabase>().then((_) => runApp(RootPage($())));
}

void uploadCallback() async {
  // TODO: instantiate the local database here since this is isolate..
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String jsonString = prefs.get(PrefsKeys.USER_DATA);
  if (jsonString != null) {
    await prefs.remove(PrefsKeys.USER_DATA).then((_) =>
        Storage(uid: Auth().getCurrentUserId()).upload(jsonDecode(jsonString)));
  }
}

class BleApp extends RouteAwareWidget<EntryEndpointBloc> {
  const BleApp(EntryEndpointBloc endpointBloc) : super(bloc: endpointBloc);

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder(
      stream: super.bloc.stream,
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

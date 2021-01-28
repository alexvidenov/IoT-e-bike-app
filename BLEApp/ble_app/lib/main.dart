import 'dart:convert';
import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:ble_app/src/blocs/entryEndpointBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/screens/entrypoints/AuthEntrypoint.dart';
import 'package:ble_app/src/screens/entrypoints/DevicesEntrypoint.dart';
import 'package:ble_app/src/screens/entrypoints/Root.dart';
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

const storageUpload = 'storageUpload';

Future<void> firebaseStorageUpload() async {
  await Firebase.initializeApp();
  print('I AM IN THE ISOLATE');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final String jsonString = prefs.get(PrefsKeys.USER_DATA);
  if (jsonString != null) {
    print('NOT NULL DATA');
    print('User Id: ' +
        Auth().getCurrentUserId()); // FIXME fix that cuz its an isolate
    await prefs.remove(PrefsKeys.USER_DATA);
    await Storage(uid: Auth().getCurrentUserId())
        .upload(jsonDecode(jsonString));
  }
}

backgroundFetchHeadlessTask(String taskId) async {
  print('HEADLESS');
  await firebaseStorageUpload();
  BackgroundFetch.finish(taskId);
}

onBackgroundFetch(String taskId) async {
  print('Running in the background (NOT HEADLESS) $taskId');
  if (taskId == storageUpload) {
    await firebaseStorageUpload();
    BackgroundFetch.finish(taskId);
  }
}

void bruh() => 1;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies();
  BleManager().createClient(restoreStateIdentifier: "com.parakatowski.ble_app");
  await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 1,
          stopOnTerminate: false,
          enableHeadless: true,
          forceAlarmManager: Platform.isAndroid),
      onBackgroundFetch);
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  BackgroundFetch.scheduleTask(TaskConfig(
      taskId: storageUpload,
      stopOnTerminate: false,
      startOnBoot: true,
      periodic: true,
      delay: 60000,
      enableHeadless: true,
      forceAlarmManager: true));
  $<CloudMessaging>().init();
  $.isReady<LocalDatabase>().then((_) => runApp(RootPage($(), $())));
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

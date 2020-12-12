library bloc;

import 'dart:convert';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/modules/jsonModels/sharedPrefsUsersDataModel.dart';
import 'package:ble_app/src/screens/settingsPage.dart';
import 'package:ble_app/src/utils/bluetoothUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/sealedAuthStates/BTAuthState.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:injectable/injectable.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ble_app/src/utils/PrefsKeys.dart';

part 'btAuthenticationBloc.dart';

part 'fullStatusBloc.dart';

part 'routeAware.dart';

part 'shortStatusBloc.dart';

part 'locationBloc.dart';

part 'deviceBloc.dart';

part 'navigationBloc.dart';

part 'navigationService.dart';

part 'devicesBloc.dart';

part 'entryEndpointBloc.dart';

part 'settingsBloc.dart';

part 'sharedPrefsBloc.dart';

part 'extensions/FullStatusParse.dart';

part 'extensions/BTAuthMethods.dart';

part 'extensions/ShortStatusParse.dart';

part 'extensions/DetermineEndpoint.dart';

part 'extensions/TrackLocation.dart';

part 'disposable.dart';

/*
mixin LifecycleDelegate {
  onCreate() {}

  onPause() {}

  onResume() {}
}
 */

// state and event
// T, S
abstract class Bloc<T, S> with _Disposable<T, S> {
  //LifecycleDelegate lifecycleDelegate;

  Stream<T> get stream => _publishSubject$.stream;

  Sink<T> get _sink => _publishSubject$.sink;

  Bloc() {
    this._publishSubject$ = BehaviorSubject<T>();
  }

  /*
  create() {
    if(lifecycleDelegate != null) _create();
  }

  pause() {
    if(lifecycleDelegate != null) _pause();
  }

  resume() {
    if(lifecycleDelegate != null) _resume();
  }
   */

  //@mustCallSuper
  //_create() => lifecycleDelegate?.onCreate();

  create() {}

  pause() {}

  resume() {}

  Function(T) get addEvent => _sink.add;

  _pauseSubscription() => streamSubscription?.pause();

  _resumeSubscription() => streamSubscription.resume();
}

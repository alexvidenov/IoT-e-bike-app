import 'package:ble_app/src/persistence/entities/deviceState.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/base/RxObject.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/persistence/entities/user.dart' as localUser;
import 'package:ble_app/src/listeners/authStateListener.dart';
import 'package:ble_app/src/sealedStates/authState.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/connectivityManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'CloudMessaging.dart';

@lazySingleton
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final LocalDatabaseManager _dbManager;

  AuthStateListener authStateListener;

  final _localAuthState = RxObject<AuthState>();

  bool _isAnonymous;

  Auth([this._dbManager]);

  void setListenerAndDetermineState(AuthStateListener listener) async {
    this.authStateListener = listener;
    auth.listen(this.authStateListener.onAuthStateChanged);
    await this.isSignedInAnonymously();
  }

  Future<bool> isSignedInAnonymously({bool isCalledFromIsolate = false}) async {
    if (await _dbManager.isAnonymous()) {
      if (!isCalledFromIsolate) {
        _localAuthState.addEvent(
            AuthState.authenticated('0000')); // FIXME fix that flying string
      }
      _isAnonymous = true;
      return true;
    } else {
      _isAnonymous = false;
      return false;
    }
  }

  Future<AuthState> signInAnonymously() {
    _dbManager.insertAnonymousUser();
    _isAnonymous = true;
    _localAuthState.addEvent(AuthState.authenticated('0000'));
    return Future.value(AuthState.authenticated('0000'));
  }

  Future<AuthState> signInWithEmailAndPassword(
      String email, String password) async {
    if (await ConnectivityManager.isOnline()) {
      User user;
      try {
        final UserCredential credential = await _auth
            .signInWithEmailAndPassword(email: email, password: password);
        user = credential?.user;
        final id = user.uid;
        print('USER ID IS $id');
        final _firestore = FirestoreDatabase(uid: id);
        if (!(await _dbManager.userExists(user.email))) {
          await _dbManager
              .insertUser(localUser.User(user.uid, user.email, password));
          final userDevicesWithParameters =
              await _firestore.fetchUserDevicesWithParams();
          print('USER DEVICES WITH PARAMETERS ARE $userDevicesWithParameters');
          await Future.forEach(userDevicesWithParameters,
              (MapEntry<Device, DeviceParameters> element) async {
            print('ELEMENT FETCHED $element');
            if (!(await _dbManager.deviceExists(element.key.id))) {
              await _dbManager.insertDevice(element.key);
              await _dbManager.insertDeviceState(DeviceState(
                  deviceNumber: element.key.id, isBatteryOn: false));
              await _dbManager.insertParameters(element.value);
            }
            await _dbManager.insertUserWithDevice(user.uid, element.key.id);
          });
        }
        _firestore.updateUserDeviceTokens(
            deviceToken: await $<CloudMessaging>().getToken());
        return AuthState.authenticated(user.uid);
      } on FirebaseAuthException catch (e) {
        return AuthState.failedToAuthenticate(
            reason: AuthExceptionHandler.handleException(e));
      }
    } else {
      localUser.User user;
      user = await _dbManager.fetchUser(email); // TODO: and password
      if (user != null) {
        _localAuthState.addEvent(AuthState.authenticated(user.id));
        return AuthState.authenticated(user.id);
      } else
        return AuthState.failedToAuthenticate(
            reason: NotAuthenticatedReason.userNotFound);
    }
  }

  Future<AuthState> signUpWithEmailAndPassword(String email, String password,
      {@required List<String> deviceIds}) async {
    User user;
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      user = credential?.user;
      if (user != null) {
        final _userId = user.uid;
        final _db = FirestoreDatabase(uid: _userId);
        final deviceWithParams =
            await _db.fetchDevicesWithParameters(ids: deviceIds);
        if (deviceWithParams != null) {
          await _db.addUser(await $<CloudMessaging>().getToken());
          await _dbManager.insertUser(localUser.User(
              _userId, email, password)); // TODO: hash password here
          await Future.forEach(deviceWithParams,
              (MapEntry<Device, DeviceParameters> element) async {
            await FirestoreDatabase(uid: _userId, deviceId: element.key.id)
                .addUserAsOwnerOfDevice();
            final serialNumber = element.key.id;
            if (!await (_dbManager.deviceExists(serialNumber))) {
              await _dbManager.insertDevice(element.key);
              await _dbManager.insertDeviceState(
                  DeviceState(deviceNumber: serialNumber, isBatteryOn: false));
              await _dbManager.insertParameters(element.value);
            }
            print('ELEMENT FETCHED $element');
            await _dbManager.insertUserWithDevice(_userId, serialNumber);
          });
          return AuthState.authenticated(user.uid);
        } else {
          return AuthState.failedToAuthenticate(
              reason: NotAuthenticatedReason.deviceSerialNumberDoesNotExist);
        }
      }
    } on FirebaseAuthException catch (e) {
      return AuthState.failedToAuthenticate(
          reason: AuthExceptionHandler.handleException(e));
    }
    return AuthState.failedToAuthenticate(
        reason: NotAuthenticatedReason.undefined);
  }

  Future<void> signOut() async {
    if (_isAnonymous) {
      _isAnonymous = false;
      _dbManager.deleteAnonymousUserDevices();
      _dbManager.deleteAnonymousUser();
      _localAuthState.addEvent(AuthState.loggedOut());
    } else {
      await _auth.signOut();
    }
  }
}

extension UserStatus on Auth {
  Stream<AuthState> get _onAuthStateChanged =>
      _auth.authStateChanges().map((user) => user == null
          ? AuthState.loggedOut()
          : AuthState.authenticated(user.uid));

  Stream<AuthState> get _onLocalAuthStateChanged => _localAuthState.stream;

  Stream<AuthState> get auth =>
      Rx.merge([_onAuthStateChanged, _onLocalAuthStateChanged]);

  String getCurrentUserId() => _isAnonymous ? '0000' : _auth.currentUser?.uid;

  bool get isAnonymous => _isAnonymous;
}

extension AuthExceptionHandler on Auth {
  static NotAuthenticatedReason handleException(FirebaseAuthException e) {
    var status;
    switch (e.code) {
      case "invalid-email":
        status = NotAuthenticatedReason.invalidEmail;
        break;
      case "wrong-password":
        status = NotAuthenticatedReason.wrongPassword;
        break;
      case "user-not-found":
        status = NotAuthenticatedReason.userNotFound;
        break;
      case "user-disabled":
        status = NotAuthenticatedReason.userDisabled;
        break;
      default:
        status = NotAuthenticatedReason.undefined;
    }
    return status;
  }
}

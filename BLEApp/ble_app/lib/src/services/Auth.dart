import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/user.dart' as localUser;
import 'package:ble_app/src/listeners/authStateListener.dart';
import 'package:ble_app/src/sealedStates/authState.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/bluetoothUtils.dart';
import 'package:ble_app/src/utils/connectivityManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'CloudMessaging.dart';

// implementation platform('com.google.firebase:firebase-bom:26.0.0')
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

  Future<bool> isSignedInAnonymously() async {
    if (await _dbManager.isAnonymous()) {
      _localAuthState.addEvent(
          AuthState.authenticated('0000')); // FIXME fix that flying string
      _isAnonymous = true;
      return true;
    } else {
      _isAnonymous = false;
      return false;
    }
  }

  Future<AuthState> signInAnonymously() {
    _dbManager.insertAnonymousUser();
    _dbManager.insertAnonymousDevice();
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
        final _firestore = FirestoreDatabase(uid: user.uid);
        /*
        if (!(await _dbManager.userExists(user.email))) {
          await _dbManager.insertUser(localUser.User(user.uid, user.email, password));
          await _dbManager.insertDevices(await _firestore.fetchUserDevices());
          await _dbManager.insertParameters();
        }
         */
        if (user != null) {
          _firestore.setUserDeviceToken(
              token:
                  await $<CloudMessaging>().getToken()); // TODO; should update
          return AuthState.authenticated(user.uid);
        }
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
    return AuthState.failedToAuthenticate(
        reason: NotAuthenticatedReason.undefined);
  }

  Future<AuthState> signUpWithEmailAndPassword(String email, String password,
      {String deviceSerialNumber}) async {
    User user;
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      user = credential?.user;
      if (user != null) {
        final _id = user.uid;
        final _db = FirestoreDatabase(uid: _id, deviceId: deviceSerialNumber);
        await _db.setUserId();
        await _db.setDeviceId();
        await _db.setDeviceName(
            name: BluetoothUtils.defaultBluetoothDeviceName);
        await _db.setUserDeviceToken(
            token: await $<CloudMessaging>().getToken());
        await _dbManager.insertUser(localUser.User(
            _id, email, password, false)); // TODO: hash password here
        await _dbManager.insertDevice(Device(
            deviceId: deviceSerialNumber,
            userId: _id,
            name: BluetoothUtils.defaultBluetoothDeviceName));
        return AuthState.authenticated(user.uid);
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
      _dbManager.deleteAnonymousUser();
      _localAuthState.addEvent(AuthState.loggedOut());
    } else {
      await _auth.signOut();
    }
  }
}

extension UserStatus on Auth {
  Stream<AuthState> get _onAuthStateChanged =>
      _auth.authStateChanges().map((user) => user != null
          ? AuthState.authenticated(user.uid)
          : AuthState.loggedOut());

  Stream<AuthState> get _onLocalAuthStateChanged => _localAuthState.stream;

  Stream<AuthState> get auth => Rx.merge(
      [_onAuthStateChanged, _onLocalAuthStateChanged]); // refactor this Rx

  String getCurrentUserId() => _isAnonymous ? '0000' : _auth.currentUser?.uid;
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

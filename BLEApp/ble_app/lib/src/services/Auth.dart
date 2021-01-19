import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/dao/deviceDao.dart';
import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/user.dart' as localUser;
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/listeners/authStateListener.dart';
import 'package:ble_app/src/sealedStates/AuthState.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/connectivityManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'CloudMessaging.dart';

@lazySingleton
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStateListener authStateListener;

  LocalDatabase _localDatabase;

  BehaviorSubject<AuthState> _behaviorSubject;

  Sink<AuthState> get _sink => _behaviorSubject.sink;

  UserDao get _userDao => _localDatabase.userDao;

  DeviceDao get _deviceDao => _localDatabase.deviceDao;

  Auth({LocalDatabase localDatabase}) {
    this._localDatabase = localDatabase;
    _behaviorSubject = BehaviorSubject<AuthState>();
  }

  Function(AuthState) get addEvent => _sink.add;

  Future<AuthState> signInWithEmailAndPassword(
      String email, String password) async {
    if (await ConnectivityManager.isOnline()) {
      User user;
      try {
        final UserCredential credential = await _auth
            .signInWithEmailAndPassword(email: email, password: password);
        user = credential?.user;
        if (user != null) {
          FirestoreDatabase(uid: user.uid)
              .setUserDeviceToken(token: await $<CloudMessaging>().getToken());
          authStateListener.onAuthSuccessful();
          return AuthState.authenticated(userId: user.uid);
        }
      } catch (e) {
        authStateListener.onLoggedOut();
        return AuthState.notAuthenticated(
            reason: AuthExceptionHandler.handleException(e));
      }
    } else {
      localUser.User user;
      user = await _userDao.fetchUser(email);
      return user != null
          ? AuthState.authenticated(userId: user.id)
          : AuthState.notAuthenticated(
              reason: NotAuthenticatedReason.userNotFound);
    }
    return AuthState.notAuthenticated(reason: NotAuthenticatedReason.undefined);
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
        final _db = FirestoreDatabase(uid: _id);
        await _db.updateUserData();
        await _db.setDeviceId(deviceId: deviceSerialNumber);
        await _userDao.insertEntity(localUser.User(_id, email, password));
        await _deviceDao.insertEntity(Device(deviceSerialNumber, _id, 'empty'));
        authStateListener.onAuthSuccessful();
        return AuthState.authenticated(userId: user.uid);
      }
    } catch (e) {
      authStateListener.onLoggedOut();
      return AuthState.notAuthenticated(
          reason: AuthExceptionHandler.handleException(e));
    }
    return AuthState.notAuthenticated(reason: NotAuthenticatedReason.undefined);
  }

  Future<void> signOut() async => await _auth.signOut().then((_) {
        addEvent(AuthState.notAuthenticated(
            reason: NotAuthenticatedReason.undefined));
        authStateListener.onLoggedOut();
      });
}

extension UserStatus on Auth {
  Stream<AuthState> get _onAuthStateChanged =>
      _auth.userChanges().map((User user) {
        if (user != null)
          return AuthState.authenticated(userId: user.uid);
        else
          return AuthState.notAuthenticated(
              reason: NotAuthenticatedReason.undefined);
      });

  Stream<AuthState> get _onLocalAuthStateChanged => _behaviorSubject.stream;

  Stream<AuthState> get combinedStream =>
      Rx.merge([_onAuthStateChanged, _onLocalAuthStateChanged]);

  String getCurrentUserId() => _auth.currentUser?.uid;
}

extension AuthExceptionHandler on Auth {
  static NotAuthenticatedReason handleException(FirebaseAuthException e) {
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = NotAuthenticatedReason.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = NotAuthenticatedReason.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
        status = NotAuthenticatedReason.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = NotAuthenticatedReason.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = NotAuthenticatedReason.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = NotAuthenticatedReason.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = NotAuthenticatedReason.emailAlreadyExists;
        break;
      default:
        status = NotAuthenticatedReason.undefined;
    }
    return status;
  }
}

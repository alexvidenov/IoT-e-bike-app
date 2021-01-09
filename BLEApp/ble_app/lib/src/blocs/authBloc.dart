import 'package:ble_app/src/listeners/AuthStateListener.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/sealedStates/AuthState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

enum AuthPage { Login, Register }

@lazySingleton
class AuthBloc extends Bloc<AuthPage, AuthPage> {
  final Auth _auth;

  AuthBloc(this._auth) : super();

  Future<AuthState> signInWithEmailAndPassword(
          {String email, String password}) async =>
      await _auth.signInWithEmailAndPassword(email, password);

  Future<AuthState> signUpWithEmailAndPassword(
          {String email, String password, String deviceId}) =>
      _auth.signUpWithEmailAndPassword(email, password,
          deviceSerialNumber: deviceId);

  Stream get authStream => _auth.combinedStream;

  String get user => _auth.getCurrentUserId();

  setListener(AuthStateListener listener) => _auth.authStateListener = listener;
}

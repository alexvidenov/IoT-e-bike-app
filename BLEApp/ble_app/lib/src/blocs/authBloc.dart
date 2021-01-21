import 'package:ble_app/src/listeners/authStateListener.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/sealedStates/authState.dart';
import 'package:injectable/injectable.dart';

enum AuthPage { Login, Register }

@lazySingleton
class AuthBloc {
  final Auth _auth;

  const AuthBloc(this._auth);

  Future<AuthState> signInWithEmailAndPassword(
          {String email, String password}) =>
      _auth.signInWithEmailAndPassword(email, password);

  Future<AuthState> signUpWithEmailAndPassword(
          {String email, String password, String deviceId}) =>
      _auth.signUpWithEmailAndPassword(email, password,
          deviceSerialNumber: deviceId);

  Stream get authStream => _auth.combinedStream;

  String get user => _auth.getCurrentUserId();

  Future<void> logout() async => await _auth.signOut();

  setListener(AuthStateListener listener) =>
      _auth.setListenerAndDetermineState(listener);
}

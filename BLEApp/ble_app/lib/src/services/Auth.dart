import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/entities/user.dart' as localUser;
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/sealedStates/AuthState.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/connectivityManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LocalDatabase _localDatabase;

  BehaviorSubject<AuthState> _behaviorSubject;

  Sink<AuthState> get _sink => _behaviorSubject.sink;

  UserDao get _userDao => _localDatabase.userDao;

  Auth({LocalDatabase localDatabase}) {
    this._localDatabase = localDatabase;
    _behaviorSubject = BehaviorSubject<AuthState>();
  }

  Function(AuthState) get addEvent => _sink.add;

  Future<AuthState> signInWithEmailAndPassword(
      String email, String password) async {
    if (await ConnectivityManager.isOnline()) {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final userId = credential?.user?.uid;
      return userId != null
          ? AuthState.authenticated(userId: userId)
          : AuthState.notAuthenticated();
    } else {
      localUser.User user;
      user = await _userDao.fetchUser(email);
      return user != null
          ? AuthState.authenticated(userId: user.id)
          : AuthState.notAuthenticated();
    }
  }

  Future<AuthState> signUpWithEmailAndPassword(
      String email, String password) async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    final _id = credential?.user?.uid;
    if (_id != null) {
      await FirestoreDatabase(uid: _id)
          .updateUserData(); // add stuff here later
      await _userDao.insertEntity(localUser.User(_id, email, password));
      return AuthState.authenticated(userId: _id);
    } else {
      return AuthState.notAuthenticated();
    }
  }

  Future<void> signOut() async =>
      await _auth.signOut().then((_) => addEvent(AuthState.notAuthenticated()));

  dispose() => _behaviorSubject.close();
}

extension UserStatus on Auth {
  Stream<AuthState> get _onAuthStateChanged =>
      _auth.authStateChanges().map((User user) {
        if (user != null)
          return AuthState.authenticated(userId: user.uid);
        else
          return AuthState.notAuthenticated();
      });

  ValueStream<AuthState> get _onLocalAuthStateChanged =>
      _behaviorSubject.stream;

  Stream<AuthState> get combinedStream =>
      Rx.merge([_onAuthStateChanged, _onLocalAuthStateChanged]);

  String getCurrentUserId() => _auth.currentUser?.uid;
}

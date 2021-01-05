import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/entities/user.dart' as localUser;
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/sealedStates/AuthState.dart';
import 'package:ble_app/src/services/Database.dart';
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
    // spot the billion dollar mistake here
    this._localDatabase = localDatabase;
    _behaviorSubject = BehaviorSubject<AuthState>();
  }

  Function(AuthState) get addEvent => _sink.add;

  // TODO: please make the return type here sealed class somehow for the love of god
  Future<String> signInWithEmailAndPassword(
      String email, String password, bool isOnline) async {
    if (isOnline) {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final userId = credential?.user?.uid;
      return userId;
    } else {
      localUser.User user;
      user = await _userDao.fetchUser(email);
      print('WE GOT USER DUDE');
      if (user != null) {
        addEvent(AuthState.authenticated(userId: user.id));
      }
    }
    return 'empty'; // FIXME lol
  }

  Future<String> signUpWithEmailAndPassword(
      String email, String password) async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    final _id = credential?.user?.uid;
    await FirestoreDatabase(uid: _id).updateUserData(); // add stuff here later
    await _userDao.insertEntity(localUser.User(_id, email, password));
    return _id;
  }

  Future<void> signOut() async =>
      await _auth.signOut().then((_) => addEvent(AuthState.notAuthenticated()));
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

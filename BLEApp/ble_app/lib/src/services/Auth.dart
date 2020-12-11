import 'package:ble_app/src/modules/sealedAuthStates/AuthState.dart';
import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/entities/user.dart' as localUser;
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/ConnectivityManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LocalDatabase _localDatabase;

  UserDao get _userDao => _localDatabase.userDao;

  BehaviorSubject<String> _behaviorSubject;

  Sink<String> get _sink => _behaviorSubject.sink;

  Function(String) get addEvent => _sink.add;

  Auth({LocalDatabase localDatabase}) {
    this._localDatabase = localDatabase;
    this._behaviorSubject = BehaviorSubject<String>();
  }

  // TODO: prolly make this generic somehow. Too much repetition.
  Future<AuthState> signInWithEmailAndPassword(
      String email, String password) async {
    if (await ConnectivityManager.isOnline() != false) {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final userId = credential?.user?.uid;
      return Authenticated(userId);
    } else {
      localUser.User user;
      user = await _userDao.fetchUser(email);
      if (user != null) {
        addEvent(user.id);
      }
      return NotAuthenticated(NotAuthenticatedError.EmailDoesNotExist);
    }
  }

  Future<AuthState> signUpWithEmailAndPassword(
      String email, String password) async {
    if (await ConnectivityManager.isOnline() != false) {
      // TODO: catch exception here and return appropriate AuthState
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final _id = credential?.user?.uid;
      await FirestoreDatabase(uid: _id)
          .updateUserData(); // add stuff here later
      await _userDao.insertEntity(localUser.User(_id, email, password));
      return Authenticated(_id);
    } else
      return NoNetwork();
  }

  Future<void> signOut() async => await _auth.signOut();

  dispose() {
    this._behaviorSubject.close();
  }
}

extension UserStatus on Auth {
  Stream<String> get _onAuthStateChanged =>
      _auth.authStateChanges().map((user) => user?.uid);

  ValueStream<String> get _onLocalAuthStateChanged => _behaviorSubject.stream;

  Stream<String> get authState =>
      Rx.merge([_onAuthStateChanged, _onLocalAuthStateChanged]);

  String getCurrentUserId() => _auth.currentUser?.uid;
}

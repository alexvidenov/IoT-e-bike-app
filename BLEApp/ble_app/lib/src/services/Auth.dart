import 'package:ble_app/src/persistence/dao/userDao.dart';
import 'package:ble_app/src/persistence/entities/user.dart' as localUser;
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalDatabase _localDatabase;

  BehaviorSubject<String> _behaviorSubject;

  Sink<String> get _sink => _behaviorSubject.sink;

  UserDao get _userDao => _localDatabase.userDao;

  Auth(this._localDatabase) {
    _behaviorSubject = BehaviorSubject<String>();
  }

  Function(String) get addEvent => _sink.add;

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
      if (user != null) {
        print('WE GOT USER BOOOOOOOYS');
        addEvent(user.id);
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

  Future<void> signOut() async => await _auth.signOut();

  dispose() {
    this._behaviorSubject.close();
  }
}

extension UserStatus on Auth {
  Stream<String> get _onAuthStateChanged =>
      _auth.authStateChanges().map((User user) => user?.uid);

  ValueStream<String> get _onLocalAuthStateChanged => _behaviorSubject.stream;

  Stream<String> get combinedStream =>
      Rx.merge([_onAuthStateChanged, _onLocalAuthStateChanged]);

  String getCurrentUserId() => _auth.currentUser?.uid;
}

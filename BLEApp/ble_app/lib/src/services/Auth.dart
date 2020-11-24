import 'package:ble_app/src/services/Database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged =>
      _auth.authStateChanges().map((User user) => user?.uid);

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential?.user?.uid;
  }

  Future<String> signUpWithEmailAndPassword(
      String email, String password) async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    final _id = credential?.user?.uid;
    await Database(uid: _id).updateUserData(); // add stuff here later
    return _id;
  }

  Future<void> signOut() async => await _auth.signOut();

  String getCurrentUserId() => _auth.currentUser?.uid;
}

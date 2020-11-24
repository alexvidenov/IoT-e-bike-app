import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final String uid; // user id

  Database({this.uid});

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData() async =>
      await _users.doc(uid).set({'id': this.uid}); // later on populate with the real user device parameters
}

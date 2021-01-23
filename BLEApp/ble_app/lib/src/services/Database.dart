import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  final String uid; // user id
  final String deviceId;

  get _firestore => FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');

  DocumentReference get _parameters => _users
      .doc(uid)
      .collection('devices')
      .doc(deviceId)
      .collection('parameters')
      .doc('parameters');

  const FirestoreDatabase({this.uid, this.deviceId});

  Future<void> updateUserData() async =>
      await _users.doc(uid).set({'id': this.uid});

  Future<void> setUserDeviceToken({@required String token}) =>
      _users.doc(uid).update({
        'token': token
      }); // make it array of tokens cuz user can have more than one device

  Future<void> setDeviceId({@required String deviceId}) =>
      _users.doc(uid).collection('devices').doc(deviceId).set({'id': deviceId});

  Future<bool> parametersExist({@required String deviceId}) async {
    final parameterDoc = await _parameters.get();
    return parameterDoc.exists;
  }

  Future<void> setDeviceParameters(Map<String, dynamic> parameters) =>
      _parameters.set(parameters);

  Future<void> setIndividualParameter(String key, dynamic value) =>
      _parameters.update({key: value});

  Stream<DocumentSnapshot> get deviceParameters => _parameters.snapshots();
}

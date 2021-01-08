import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  final String uid; // user id

  static CollectionReference get _users =>
      FirebaseFirestore.instance.collection('users');

  const FirestoreDatabase({this.uid});

  Future<void> updateUserData() async =>
      await _users.doc(uid).set({'id': this.uid});

  Future<void> updateDeviceData({@required String deviceId}) async =>
      await _users.doc(uid).collection('devices').doc(deviceId).set({
        'id': deviceId
      }); // later on populate with the real device parameters

}

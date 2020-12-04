import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database {
  final String uid; // user id

  Database({this.uid}) ;

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData() async =>
      await _users.doc(uid).set({'id': this.uid});

  Future<void> updateDeviceData({@required String deviceId}) async =>
      await _users.doc(uid).collection('devices').doc(deviceId).set({
        'id': deviceId
      }); // later on populate with the real device parameters
}

import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/utils/bluetoothUtils.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  final String uid;
  final String deviceId;

  const FirestoreDatabase({this.uid, this.deviceId});

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');

  CollectionReference get _devices => _firestore.collection('devices');

  DocumentReference get _device => _devices.doc(deviceId);

  DocumentReference get _user => _users.doc(uid);

  CollectionReference get _deviceMessages => _device.collection('messages');

  DocumentReference get _deviceIdGenerator =>
      _firestore.collection('deviceId').doc('currentId');

  Future<void> uploadDevice(
      {String macAddress,
      bool isSuperDevice = false,
      Map<String, dynamic> parameters}) async {
    _device.set({
      'MAC': macAddress,
      'createdAt': FieldValue.serverTimestamp(),
      'isSuper': isSuperDevice,
      'name': BluetoothUtils.defaultBluetoothDeviceName,
      'parameters': parameters ?? {},
      'userIds': []
    });
    //final lastDeviceId = (await _deviceIdGenerator.get()).get('id');
    //_deviceIdGenerator.update({'id': lastDeviceId + 1});
  }

  Future<MapEntry<Device, DeviceParameters>> fetchDeviceWithParameters(
      {String id}) async {
    // Should accepts list of ids (register three devices at once is possible for example) )
    final device = await _devices.doc(id ?? this.deviceId).get();
    if (device.exists) {
      final id2 = device.id;
      print('DEVICE IS IS $id2');
      return MapEntry(
          Device(
              deviceId: id ?? this.deviceId,
              userId: this.uid,
              macAddress: device.get('MAC'),
              name: device.get('name'),
              isSuper: device.get('isSuper')),
          DeviceParameters.fromMap(device.get('parameters')));
    } else
      return null; // here the bloc calling this DB service should emit state saying that the device number is wrong
  }

  Future<DeviceParameters> fetchDeviceParameters({String id}) async {
    final Map<String, dynamic> _params =
        (await _devices.doc(id ?? this.deviceId).get()).get('parameters');
    return DeviceParameters.fromMap(_params);
  }

  Future<void> addUser(String deviceToken) => _user.set({
        'devices': [deviceId],
        'tokens': [deviceToken]
      });

  Future<void> updateUserDeviceTokens({String deviceToken}) => _user.update({
        'tokens': FieldValue.arrayUnion([deviceToken]),
      });

  Future<void> addUserAsOwnerOfDevice() => _device.update({
        // will be called from registering another device
        'userIds': FieldValue.arrayUnion([uid]),
      });

  Future<void> updateUserDevices() => _user.update({
        // will be called from registering another device
        'devices': FieldValue.arrayUnion([deviceId]),
      });

  Future<void> updateIndividualParameter(String key, dynamic value) =>
      _device.update({'parameters.$key': value});

  Future<void> updateDeviceName({@required String name}) =>
      _device.update({'Name': name});

  Future<List<MapEntry<Device, DeviceParameters>>>
      fetchUserDevicesWithParams() async {
    final devicesWithParameters = List<MapEntry<Device, DeviceParameters>>();
    final List<dynamic> deviceListIds =
        await (await _user.get()).get('devices');
    await Future.forEach(
        deviceListIds,
        (id) async =>
            devicesWithParameters.add(await fetchDeviceWithParameters(id: id)));
    return devicesWithParameters;
  }

  Future<void> addError(ServiceNotification notification) =>
      _device.collection('errors').doc().set({
        'from': uid,
        'reason': notification.state.string(),
        'timeStamp': DateTime.now(),
      });

  Future<void> sendMessage(String message) =>
      _device.collection('messages').doc().set({
        'from': uid,
        'message': message,
        'timeStamp': DateTime.now(),
      });

  Stream<List<DocumentSnapshot>> lastMessages() => _deviceMessages
      .orderBy('timeStamp', descending: true)
      .limit(20)
      .snapshots()
      .map((snap) => snap.docs);
}

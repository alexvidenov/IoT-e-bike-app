import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  final String uid; // user id
  final String deviceId;

  get _firestore => FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');

  DocumentReference get _device =>
      _users.doc(uid).collection('devices').doc(deviceId);

  DocumentReference get _parameters => _users
      .doc(uid)
      .collection('devices')
      .doc(deviceId)
      .collection('parameters')
      .doc('parameters');

  const FirestoreDatabase({this.uid, this.deviceId});

  Future<void> setUserId() => _users.doc(uid).set({'id': this.uid});

  Future<void> setUserDeviceToken({@required String token}) =>
      _users.doc(uid).update({
        'token': token
      }); // make it array of tokens cuz user can have more than one device

  Future<void> setDeviceId() => _device.set({'id': this.deviceId});

  Future<List<Device>> fetchUserDevices() async {
    var _devices = List<Device>();
    final devices = await _users.doc(uid).collection('devices').get();
    devices.docs.forEach((device) {
      _devices.add(Device(
          deviceId: device.get('id'), // or just .id
          userId: this.uid,
          name: device.get('name'),
          macAddress: device.get('MAC')));
    });
    return _devices;
  }

  Future<void> setDeviceMacAddress({@required String mac}) =>
      _device.update({'MAC': mac});

  Future<void> setDeviceName({@required String name}) =>
      _device.update({'name': name});

  Future<bool> parametersExist({@required String deviceId}) async {
    final parameterDoc = await _parameters.get();
    return parameterDoc.exists;
  }

  Future<void> setDeviceParameters(Map<String, dynamic> parameters) =>
      _parameters.set(parameters);

  // ignore: missing_return
  Future<DeviceParameters> fetchDeviceParameters(String id) async {
    final _params = await _parameters.get();
    // TODO: return DeviceParameters(id: this.deviceId, cellCount: _params.get('00'), maxCellVoltage: _params, maxRecoveryVoltage: null, balanceCellVoltage: null, minCellVoltage: null, minCellRecoveryVoltage: null, ultraLowCellVoltage: null, maxTimeLimitedDischargeCurrent: null, maxCutoffDischargeCurrent: null, maxCurrentTimeLimitPeriod: null, maxCutoffChargeCurrent: null, motoHoursCounterCurrentThreshold: null, currentCutOffTimerPeriod: null, maxCutoffTemperature: null, maxTemperatureRecovery: null, minTemperatureRecovery: null, minCutoffTemperature: null, motoHoursChargeCounter: null, motoHoursDischargeCounter: null)
  }

  Future<void> setIndividualParameter(String key, dynamic value) =>
      _parameters.update({key: value});
}

import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  final String uid;
  final String deviceId;

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  CollectionReference get _users => _firestore.collection('users');

  DocumentReference get _device =>
      _users.doc(uid).collection('devices').doc(deviceId);

  DocumentReference _parameters([String id]) => _users
      .doc(uid)
      .collection('devices')
      .doc(id ?? this.deviceId)
      .collection('parameters')
      .doc('parameters');

  const FirestoreDatabase({this.uid, this.deviceId});

  Future<void> setUserId() => _users.doc(uid).set({'id': this.uid});

  Future<void> setUserDeviceToken({@required String token}) =>
      _users.doc(uid).update({
        'token': token
      }); // make it array of tokens cuz user can have more than one device

  Future<void> setDeviceId() => _device.set({'id': this.deviceId});

  Future<List<MapEntry<Device, DeviceParameters>>>
      fetchUserDevicesWithParams() async {
    final _devices = List<MapEntry<Device, DeviceParameters>>();
    final devices = await _users.doc(uid).collection('devices').get();
    await Future.forEach(devices.docs, (device) async {
      final id = device.get('id');
      print('ID IS $id');
      final params = await this.fetchDeviceParameters(id);
      print('PARAMS ARE $params');
      _devices.add(MapEntry(
          Device(
              deviceId: id,
              userId: this.uid,
              name: device.get('name'),
              macAddress: device.get('MAC')),
          params));
    });
    return _devices;
  }

  Future<DeviceParameters> fetchDeviceParameters(String id) async {
    final _params = await _parameters(id).get();
    return DeviceParameters(
        id: id,
        cellCount: (_params.get('00') as double).toInt(),
        maxCellVoltage: _params.get('01'),
        maxRecoveryVoltage: _params.get('02'),
        balanceCellVoltage: _params.get('03'),
        minCellVoltage: _params.get('04'),
        minCellRecoveryVoltage: _params.get('05'),
        ultraLowCellVoltage: _params.get('06'),
        maxTimeLimitedDischargeCurrent: _params.get('12'),
        maxCutoffDischargeCurrent: _params.get('13'),
        maxCurrentTimeLimitPeriod: (_params.get('14') as double).toInt(),
        maxCutoffChargeCurrent: _params.get('15'),
        motoHoursCounterCurrentThreshold: (_params.get('16') as double).toInt(),
        currentCutOffTimerPeriod: (_params.get('17') as double).toInt(),
        maxCutoffTemperature: (_params.get('23') as double).toInt(),
        maxTemperatureRecovery: (_params.get('24') as double).toInt(),
        minTemperatureRecovery: (_params.get('25') as double).toInt(),
        minCutoffTemperature: (_params.get('26') as double).toInt(),
        motoHoursChargeCounter: (_params.get('28') as double).toInt(),
        motoHoursDischargeCounter: (_params.get('29') as double).toInt());
  }

  Future<void> setDeviceMacAddress({@required String mac}) =>
      _device.update({'MAC': mac});

  Future<void> setDeviceName({@required String name}) =>
      _device.update({'name': name});

  Future<bool> parametersExist({@required String deviceId}) async {
    final parameterDoc = await _parameters().get();
    return parameterDoc.exists;
  }

  Future<void> setDeviceParameters(Map<String, dynamic> parameters) =>
      _parameters().set(parameters);

  Future<void> setIndividualParameter(String key, dynamic value) =>
      _parameters().update({key: value});

  Future<void> updateArray() {
    _firestore.collection('users').doc('someuser').update({
      'devices': FieldValue.arrayUnion(['newdeviceid'])
    });
  }

  Future<void> setArray() {
    _firestore.collection('users').doc('someuser').set({
      'devices': [123, 124]
    });
  }
}

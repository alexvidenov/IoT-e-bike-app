import 'dart:convert';
import 'dart:typed_data';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Storage {
  final String uid; // user id
  final String deviceSerialNumber;

  final Reference _root = FirebaseStorage.instance.ref();

  Storage({this.uid, this.deviceSerialNumber});

  Future<void> upload(List<dynamic> data) async {
    final appData = AppData.fromJson(data);
    for (final user in appData.usersData) {
      for (final log in user.userLog) {
        if (log.deviceId != null) {
          await _convertToUInt8ListAndUpload(
              data: log.deviceLog,
              userId: user.userId,
              deviceSerialNumber: log.deviceId);
        }
      }
    }
    print('UPLOADING DONE');
  }

  Future<void> _convertToUInt8ListAndUpload(
      {@required List<dynamic> data,
      @required String userId,
      @required String deviceSerialNumber}) async {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(data);
    List<int> bytes = utf8.encode(jsonString);
    String base64str = base64.encode(bytes);
    Uint8List uploadData = base64.decode(base64str);

    DateTime dateTime = DateTime.now();

    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();

    String fileName = year + month + day + '.json';

    print('UPLOADING ON /devices/$deviceSerialNumber/$userId/$fileName');

    Reference fileRef =
        _root.child('/devices/$deviceSerialNumber/$userId/$fileName');

    await fileRef
        .putData(uploadData, SettableMetadata(contentType: 'application/json'))
        .whenComplete(() => {});
  }

  // Fetches concurrently an arbitrary number of json files, applies custom Model fromJson to all of them, flattens the resulted list and returns it
  Future<List<LogModel>> downloadAll() async =>
      (await Future.wait<Response<List<dynamic>>>((await FirebaseStorage
                  .instance
                  .ref()
                  .child('/devices/$deviceSerialNumber/$uid')
                  .listAll())
              .items
              .map((ref) async =>
                  Dio().get<List<dynamic>>(await ref.getDownloadURL()))))
          .map((l) => l.data.map((e) => LogModel.fromJson(e)))
          .expand((m) => m)
          .toList();

  Future<List<LogModel>> downloadOne(String fileName) async {
    final references =
        await _root.child('/devices/$deviceSerialNumber/$uid/$fileName');
    final url = await references.getDownloadURL();
    final data = await Dio().get<List<dynamic>>(url);
    return data.data.map((e) => LogModel.fromJson(e)).toList();
  }

  Future<List<String>> fetchList() async {
    final references =
        await _root.child('/devices/$deviceSerialNumber/$uid').listAll();
    final items = references.items;
    print('ITEMS ARE $items');
    print('First name is ' + items.first.name);
    return items.map((e) => e.name).toList();
  }
}

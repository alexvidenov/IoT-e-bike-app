import 'dart:convert';
import 'dart:typed_data';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final String uid; // user id

  final Reference _root = FirebaseStorage.instance.ref();

  Storage({this.uid});

  Future<void> upload(List<dynamic> data) async {
    final appData = AppData.fromJson(data);
    for (final user in appData.usersData) {
      for (final log in user.userLog) {
        if (log.deviceId != null) {
          await _convertToUInt8ListAndUpload(log.deviceLog, log.deviceId);
        }
      }
    }
    print('UPLOADING DONE');
  }

  Future<void> _convertToUInt8ListAndUpload(
      List<dynamic> data, String deviceSerialNumber) async {
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

    print('UPLOADING ON $uid/$deviceSerialNumber/$fileName');

    Reference fileRef =
        _root.child('/users/$uid/$deviceSerialNumber/$fileName');

    await fileRef
        .putData(uploadData, SettableMetadata(contentType: 'application/json'))
        .whenComplete(() => {});
  }

  // Fetches concurrently an arbitrary number of json files, applies custom Model fromJson to all of them, flattens the resulted list and returns it
  Future<List<LogModel>> download() async =>
      (await Future.wait<Response<List<dynamic>>>((await FirebaseStorage
                  .instance
                  .ref()
                  .child('/users/5YQFtZI5QsRsXVcd1ZB8JSamjjj2/1234457')
                  .listAll())
              .items
              .map((ref) async =>
                  Dio().get<List<dynamic>>(await ref.getDownloadURL()))))
          .map((l) => l.data.map((e) => LogModel.fromJson(e)))
          .expand((m) => m)
          .toList();
}

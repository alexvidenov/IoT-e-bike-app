import 'dart:convert';
import 'dart:typed_data';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final String uid; // user id

  Storage({this.uid});

  final StorageReference _root = FirebaseStorage.instance.ref();

  Future<void> upload(List<dynamic> data) async {
    final appData = AppData.fromJson(data);
    for (final user in appData.usersData) {
      for (final log in user.userLog) {
        if (log.deviceId != null) {
          await _convertToUInt8ListAndUpload(log.deviceLog, log.deviceId);
        }
      }
    }
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

    StorageReference fireRef =
        _root.child('/users/$uid/$deviceSerialNumber/$fileName');

    await fireRef
        .putData(uploadData)
        .onComplete
        .then((_) => print('Finished uploading one thing'));
  }
}

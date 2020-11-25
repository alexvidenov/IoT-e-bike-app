import 'dart:convert';
import 'dart:typed_data';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final String uid; // user id

  Storage({this.uid});

  final StorageReference _root = FirebaseStorage.instance.ref();

  void upload(List<dynamic> data) {
    // this will be the AppData class
    if (data != null) {
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

      String deviceId = DeviceRepository()
          .deviceId; // actually keep the device Id in SharedPrefs // am i retarded, this is a new instance of a repository (in the isolate).

      StorageReference fireRef = _root.child(
          '/users/$uid/$deviceId/$fileName'); // later on use the list API to list every file under /users/$uid. And also add additional folder, which will be hte device serial number.

      fireRef.putData(uploadData);
    }
  }
}

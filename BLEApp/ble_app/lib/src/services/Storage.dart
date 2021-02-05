import 'dart:convert';
import 'dart:typed_data';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';
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

    await fileRef.putData(uploadData).whenComplete(() => {});
  }

  Future<String> download() async {
    // test user
    final userId = "5YQFtZI5QsRsXVcd1ZB8JSamjjj2";
    final deviceNumber = "1234457";
    final builder = StringBuffer();
    final Reference ref = _root.child('/users/$userId/$deviceNumber');
    final files = await ref.listAll();
    final Reference file = files.items.elementAt(3);
    final bytes = await file.getData();

    StringBuffer buffer = new StringBuffer();
    for (int i = 0; i < bytes.length;) {
      int firstWord = (bytes[i] << 8) + bytes[i + 1];
      if (0xD800 <= firstWord && firstWord <= 0xDBFF) {
        int secondWord = (bytes[i + 2] << 8) + bytes[i + 3];
        buffer.writeCharCode(
            ((firstWord - 0xD800) << 10) + (secondWord - 0xDC00) + 0x10000);
        i += 4;
      } else {
        buffer.writeCharCode(firstWord);
        i += 2;
      }
    }
    final String json = buffer.toString();
    final size = bytes.lengthInBytes;
    print('DATA IS: $json');
    print('AND HAS SIZE: $size');
    /*
    await Future.forEach(files.items, (Reference ref) async {
      print('REFERENCE HERE');
      final data = await ref.getData();
      final string = String.fromCharCodes(data); // this is assigned 30% of **data**.
      print('DATA IS: $string');
      builder.write(String.fromCharCodes(data));
    });
     */
    return builder.toString();
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final String uid; // user id

  Storage({this.uid});

  final StorageReference _root = FirebaseStorage.instance.ref();

  void upload(Map<String, Map<String, double>> data) {
    if (data != null) {
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String jsonString = encoder.convert(data);
      //String jsonString = jsonEncode(data);
      List<int> bytes = utf8.encode(jsonString);
      String base64str = base64.encode(bytes);
      Uint8List uploadData = base64.decode(base64str); 

      StorageReference fireRef = _root.child('/users/$uid/data.json');

      fireRef.putData(uploadData);
    }
  }
}

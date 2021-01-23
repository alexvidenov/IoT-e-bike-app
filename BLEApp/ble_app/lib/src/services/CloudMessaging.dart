import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print('ON BACKGROUND CALLED');
  final LocalDatabase localDatabase = await LocalDatabase.getInstance();
  if (message.containsKey('data')) {
    final String data =
        message['data']['01'].toString(); // later on do stuff with that
    //localDatabase.deviceDao
      //  .insertEntity(Device('Id', 'FROM FCM IN THE BACKGROUND', data, ""));
  }
}

@lazySingleton
class CloudMessaging {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  init() => _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onBackgroundMessage: myBackgroundMessageHandler);

  Future<String> getToken() async => await _fcm.getToken();
}

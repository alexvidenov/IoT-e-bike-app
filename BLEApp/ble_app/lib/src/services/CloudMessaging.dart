import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    await prefs.setString('NotificationData', data.toString());
  }
  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    await prefs.setString('Notification', notification.toString());
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
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onBackgroundMessage: myBackgroundMessageHandler);

  Future<String> getToken() async => await _fcm.getToken();
}

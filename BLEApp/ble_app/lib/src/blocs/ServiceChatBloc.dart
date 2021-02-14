import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class ServiceChatBloc
    extends Bloc<List<MapEntry<String, String>>, List<DocumentSnapshot>>
    with CurrentContext {
  @override
  create() => streamSubscription =
      FirestoreDatabase(uid: curUserId, deviceId: curDeviceId)
          .lastMessages()
          .listen((event) => addEvent(event
              .map((snap) => MapEntry(snap.get('from') as String, snap.get('message') as String))
              .toList()));

  void sendMessage(String message) =>
      FirestoreDatabase(uid: curUserId, deviceId: curDeviceId)
          .sendMessage(message);
}

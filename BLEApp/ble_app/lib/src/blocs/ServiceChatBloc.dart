import 'package:ble_app/src/blocs/mixins/CurrentContext.dart';
import 'package:ble_app/src/blocs/base/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:phoenix_socket/phoenix_socket.dart';

@injectable
class ServiceChatBloc extends Bloc<void, void> with CurrentContext {
  final _socket = PhoenixSocket('ws://192.168.0.107:4000/socket/websocket');

  @override
  create() async {
    await _socket.connect();
    await setupChannel();
  }

  Future<void> setupChannel() async {
    final channel = _socket.addChannel(topic: 'room:lobby');

    channel.messages.listen((message) {
      if (message.event == PhoenixChannelEvent.custom('shout')) {
        print('SHOUTING: ' + message.payload['test']);
      }
      print('MESSAGE: ${message.payload}');
    });

    await channel.join().future.then((value) => print('PUSH: ${value}'));
  }
}

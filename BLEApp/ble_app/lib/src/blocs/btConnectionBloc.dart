import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ConnectionEvent { Connecting, Connected, FailedToConnect }

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionEvent> {
  @override
  get initialState => ConnectionEvent.Connecting;

  @override
  Stream<ConnectionEvent> mapEventToState(ConnectionEvent event) async* {
    yield event;
  }
}

import 'package:rxdart/rxdart.dart';

enum Endpoint { Unknown, DevicesScreen, AuthScreen }

class EntryEndpointBloc {
  BehaviorSubject<Endpoint> _endpointController;
  Stream<Endpoint> get endpointStream => _endpointController.stream;

  Sink<Endpoint> get _setEndpoint => _endpointController.sink;

  Function(Endpoint) get setEndpoint => _setEndpoint.add;

  EntryEndpointBloc() {
    _endpointController = BehaviorSubject<Endpoint>();
  }

  dispose() {
    _endpointController.close();
  }
}

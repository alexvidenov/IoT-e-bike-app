import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get_it/get_it.dart';
import 'package:ble_app/src/blocs/bloc.dart';

class ConnectionBloc extends Bloc<BluetoothDeviceState> {
  ConnectionBloc() {
    GetIt.I<BluetoothRepository>().connectionStream.listen((event) {
      // rename the repo status to something else to make more sense. Here, just switch the repo status and emit ConnectionEvent.
      behaviourSubject$.sink.add(event);
    });
  }

  connect() {
    GetIt.I<BluetoothRepository>().connectToDevice();
  }

  disconnect() {
    GetIt.I<BluetoothRepository>().disconnectFromDevice();
  }
}

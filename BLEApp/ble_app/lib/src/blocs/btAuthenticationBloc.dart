import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:get_it/get_it.dart';

class BluetoothAuthBloc extends Bloc<bool, String> {
  BluetoothRepository _repository;

  BluetoothAuthBloc() {
    addEvent(false);
    _repository = GetIt.I<BluetoothRepository>();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      if (event.length > 1) {
        addEvent(
            true); // that means that the characteristic emitted something, and that is the password since at that time, nothing else is to be emitted.
      }
    });
  }

  authenticate(String password) {
    _repository.writeToCharacteristic(password);
  }
}

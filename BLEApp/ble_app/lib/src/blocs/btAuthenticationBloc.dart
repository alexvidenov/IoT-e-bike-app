import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';

class BluetoothAuthBloc extends Bloc<bool, String> {
  final DeviceRepository _repository;

  BluetoothAuthBloc(this._repository) : super() {
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      if (event.startsWith('pass')) {
        // later on change to what the actual parameter name will be
        addEvent(true);
      }
    });
  }

  authenticate(String password) => _repository.writeToCharacteristic(password);

  changePassword(String newPassword) =>
      _repository.writeToCharacteristic(newPassword);
}

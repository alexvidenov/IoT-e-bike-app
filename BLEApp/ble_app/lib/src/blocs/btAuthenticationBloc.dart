import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Database.dart';

class BluetoothAuthBloc extends Bloc<bool, String> {
  final DeviceRepository _repository;

  BluetoothAuthBloc(this._repository) : super();

  @override
  void create() => streamSubscription =
          _repository.characteristicValueStream.listen((event) {
        if (event.startsWith('pass')) {
          //List<String> objects = event.split(' ');
          //String deviceId = objects.elementAt(1);
          // later on change to what the actual parameter name will be
          _repository.deviceSerialNumber = 1234457.toString();
          Database(uid: Injector.$<Auth>().getCurrentUserId())
              .updateDeviceData(deviceId: '1234457'); // just for simpler tests
          addEvent(true);
        }
      });

  @override
  void pause() => pauseSubscription();

  @override
  void resume() => resumeSubscription();

  authenticate(String password) => _repository.writeToCharacteristic(password);

  changePassword(String newPassword) =>
      _repository.writeToCharacteristic(newPassword);
}

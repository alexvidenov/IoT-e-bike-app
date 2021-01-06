import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/sealedStates/BTAuthState.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:injectable/injectable.dart';

@injectable
class BluetoothAuthBloc extends Bloc<BTAuthState, String> {
  final DeviceRepository _repository;
  final LocalDatabase _db;
  final Auth _auth;

  BluetoothAuthBloc(this._repository, this._db, this._auth) : super();

  @override
  void create() => streamSubscription =
          _repository.characteristicValueStream.listen((event) async {
        if (event.startsWith('pass')) {
          //List<String> objects = event.split(' ');
          //String deviceId = objects.elementAt(1);
          // later on change to what the actual parameter name will be
          final userId = _auth.getCurrentUserId();
          //if (!await checkUserExistsWithDevice('', userId)) {
          //addEvent(BTAuthState.bTNotAuthenticated(
          //reason: BTNotAuthenticatedReason.DeviceDoesNotExist));
          //}
          _repository.deviceSerialNumber = 1234457.toString();
          FirestoreDatabase(uid: userId)
              .updateDeviceData(deviceId: '1234457'); // just for simpler tests
          addEvent(BTAuthState.bTAuthenticated());
        }
      });

  @override
  void pause() => pauseSubscription();

  @override
  void resume() => resumeSubscription();
}

extension BTAuthMethods on BluetoothAuthBloc {
  authenticate(String password) => _repository.writeToCharacteristic(password);

  changePassword(String newPassword) =>
      _repository.writeToCharacteristic(newPassword);

  Future<bool> checkUserExistsWithDevice(
      String serialNumber, String userId) async {
    final userId = _auth.getCurrentUserId();
    return await _db.deviceDao.fetchDevice(serialNumber, userId) != null;
  }
}

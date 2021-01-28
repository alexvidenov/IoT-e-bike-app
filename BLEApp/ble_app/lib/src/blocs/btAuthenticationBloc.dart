import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/sealedStates/btAuthState.dart';
import 'package:injectable/injectable.dart';

part 'blocExtensions/BTAuthMethods.dart';

@injectable
class BluetoothAuthBloc extends Bloc<BTAuthState, String> {
  final DeviceRepository _repository;
  final LocalDatabaseManager _db;

  BluetoothAuthBloc(this._repository, this._db) : super();

  @override
  create() => streamSubscription =
          _repository.characteristicValueStream.listen((event) async {
        print(event);
        if (event.startsWith('OK')) {
          this.pause();
          //List<String> objects = event.split(' ');
          //String deviceId = objects.elementAt(1);
          // later on change to what the actual parameter name will be
          //final userId = _auth.getCurrentUserId();
          //if (!await checkUserExistsWithDevice('1234457', userId)) {
          // just for simpler tests
          //addEvent(BTAuthState.bTNotAuthenticated(
          //reason: BTNotAuthenticatedReason.DeviceDoesNotExist));
          //}x
          //else{
          //_db.deviceDao.setMacAddress(_re, int.parse(_repository.deviceId));
          if (await _db.isAnonymous()) {
            // not the right method tho
            _repository.deviceSerialNumber = '1234';
          } else {
            _repository.deviceSerialNumber =
                1234567.toString(); // TODO: fetch 55 param here (for example)
          }
          addEvent(BTAuthState.btAuthenticated());
          // }
        }
      });

  @override
  dispose() {
    logger.wtf('Closing stream in BTAuthenticationBloc');
    super.dispose();
  }
}

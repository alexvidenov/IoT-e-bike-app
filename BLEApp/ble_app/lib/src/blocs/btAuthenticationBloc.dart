import 'package:ble_app/src/blocs/LocalDatabaseManager.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/sealedStates/btAuthState.dart';
import 'package:injectable/injectable.dart';

import 'CurrentContext.dart';

part 'blocExtensions/BTAuthMethods.dart';

@injectable
class BluetoothAuthBloc extends Bloc<BTAuthState, String> with CurrentContext {
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
          _repository.deviceSerialNumber = 1234567
              .toString(); // TODO: fetch 55 param here (for example)
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

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/sealedStates/btAuthState.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:injectable/injectable.dart';

part 'blocExtensions/BTAuthMethods.dart';

@injectable
class BluetoothAuthBloc extends Bloc<BTAuthState, String> {
  final DeviceRepository _repository;
  final LocalDatabase _db;
  final Auth _auth;

  BluetoothAuthBloc(this._repository, this._db, this._auth) : super();

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
          //}
          //else{
          _repository.deviceSerialNumber = 1234457.toString();
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

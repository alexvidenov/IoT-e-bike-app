import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/events/BTAuthEvents.dart';
import 'package:ble_app/src/main.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/sealedStates/BTAuthState.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:injectable/injectable.dart';

part '../extensions/BTAuthMethods.dart';

@injectable
class BluetoothAuthBloc extends Bloc<BTAuthState, BTAuthEvent> {
  final DeviceRepository _repository;
  final LocalDatabase _db;
  final Auth _auth;

  BluetoothAuthBloc(this._repository, this._db, this._auth) : super();

  @override
  create() => streamSubscription = _repository.characteristicValueStream
      .map((event) => BTAuthEvent.authenticate(event))
      .listen((event) async => addState(event));

  //Future.delayed(Duration(seconds: 5), () {
  //addEvent(BTAuthState.bTAuthenticated());
  //});

  @override
  pause() => pauseSubscription();

  @override
  resume() => resumeSubscription();

  @override
  dispose() {
    logger.wtf('Closing stream in BTAuthenticationBloc');
    super.dispose();
  }

  @override
  BTAuthState mapEventToState(BTAuthEvent event) {
    event.when(authenticate: (auth) {
      if (auth.startsWith('pass')) {
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
        return BTAuthState.btAuthenticated();
        // }
      }
    });
  }
}

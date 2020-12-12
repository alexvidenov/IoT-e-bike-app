part of bloc;

@injectable
class BluetoothAuthBloc extends Bloc<BTAuthState, String> {
  final DeviceRepository _repository;

  final LocalDatabase _localDatabase;

  final Auth _auth;

  BluetoothAuthBloc(this._repository, this._auth, this._localDatabase)
      : super();

  @override
  create() {
    super.create();
    streamSubscription =
        _repository.characteristicValueStream.listen((event) async {
      if (event.startsWith('pass')) {
        final currentUser = _auth.getCurrentUserId();
        //ist<String> objects = event.split(' ');
        //String deviceId = objects.elementAt(1);q
        // later on change to what the actual parameter name will be
        final deviceId = '1234457';
        //if (await checkUserExistsWithDevice(deviceId, currentUser)) {
        _repository.deviceSerialNumber = deviceId.toString();
        FirestoreDatabase(uid: currentUser)
            .updateDeviceData(deviceId: deviceId); // just for simpler tests
        addEvent(BTAuthenticated());
        //} else {
        //addEvent(BTNotAuthenticated(
        // NotBTAuthenticatedError.DeviceIsNotRegistered));
        //}
      } else {
        addEvent(BTNotAuthenticated(NotBTAuthenticatedError.WrongPassword));
      }
    });
  }

  @override
  pause() {
    _pauseSubscription();
  }

  @override
  resume() {
    _resumeSubscription();
  }
}

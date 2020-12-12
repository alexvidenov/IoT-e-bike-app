part of bloc;

@injectable
class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  final DeviceRepository _repository;
  final SettingsBloc _settingsBloc;
  final Auth _auth;

  int _uploadTimer = 0;

  AppData _appData;

  ShortStatusBloc(this._repository, this._settingsBloc, this._auth) : super();

  // TODO: actually fix the disposing of the damn writeMethod here
  @override
  pause() {
    super.pause();
    _repository.cancel();
    _pauseSubscription();
  }

  @override
  resume() {
    super.resume();
    _repository.resumeTimer(true);
    _resumeSubscription();
  }

  @override
  create() {
    super.create();
    _initData();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      ShortStatusModel _model = _generateShortStatus(event);
      addEvent(_model);
      _uploadTimer++;
      if (_uploadTimer == 10) {
        _appData.addCurrentRecord({
          'timeStamp': DateTime.now().toString(),
          'stats': {
            'voltage': _model.totalVoltage,
            'temp': _model.temperature,
            'currentCharge': _model.currentCharge,
            'currentDischarge': _model.currentDischarge,
          }
        });
        _uploadTimer = 0;
        _settingsBloc
            .setUserData(jsonEncode(_appData.toJson())); // list of userData
      }
    });
  }

  _initData() {
    final data = _settingsBloc.getUserData();
    final userId = _auth.getCurrentUserId();
    final deviceId = _repository.deviceId;
    data != 'empty'
        ? _appData = AppData.fromJson(jsonDecode(data),
            userId: userId, deviceSerialNumber: deviceId)
        : _appData = AppData(userId: userId, deviceSerialNumber: deviceId);
  }
}

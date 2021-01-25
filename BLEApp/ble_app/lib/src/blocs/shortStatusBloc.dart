import 'dart:convert';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/DataCachingManager.dart';
import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';

import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/modules/jsonClasses/sharedPrefsUsersDataModel.dart';
import 'package:ble_app/src/sealedStates/shortStatusState.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:injectable/injectable.dart';

part 'blocExtensions/ShortStatusParse.dart';

@injectable
class ShortStatusBloc extends ParameterAwareBloc<ShortStatusState, String>
    with CurrentContext, DataCachingManager {
  final DeviceRepository _repository;
  final SettingsBloc _settingsBloc;
  final Auth _auth;

  final tempConverter = TemperatureConverter();

  int _uploadTimer = 0;

  AppData
      _appData; // appData is continuously evolving even if upload occurs -> we should bind this appData instance to the upload somehow

  ShortStatusBloc(this._repository, this._settingsBloc, this._auth) : super();

  @override
  pause() {
    super.pause();
    _repository.cancel();
  }

  @override
  resume() {
    super.resume();
    _repository.resumeTimer(true);
  }

  @override
  create() {
    _initData();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      logger.wtf('SHORT STATUS EVENT: $event');
      ShortStatusState _model = _generateShortStatus(
          event); // TODO: add method checking for abnormalities.
      addEvent(_generateShortStatus(event));
      //addEvent(ShortStatusState.error(, errorState))
      _uploadTimer++;
      if (_uploadTimer == 10) {
        // TODO: extract data logging process in a separate manager (mixin) just like the delta calculation
        _appData.addCurrentRecord({
          'timeStamp': DateTime.now().toString(),
          'stats': {
            'voltage': _model.model.totalVoltage,
            'temp': _model.model.temperature,
            'current': _model.model.current
            // TODO: add the delta here
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

  @override
  dispose() {
    logger.wtf('Closing stream in Short Status Bloc');
    super.dispose();
  }
}

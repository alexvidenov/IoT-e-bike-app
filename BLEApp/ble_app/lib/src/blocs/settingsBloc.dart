import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:ble_app/src/blocs/sharedPrefsService.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

enum ConnectionSettings { Manual, AutoConnect, AutoPassword }

@lazySingleton
class SettingsBloc {
  final _passwordRx = RxObject<String>();
  final _connectionRx = RxObject<ConnectionSettings>();

  final SharedPrefsService _preferencesService;

  SettingsBloc(this._preferencesService);

  String getUserData() => _preferencesService.userData() ?? 'empty';

  bool isFirstTime() {
    final isFirstTime = _preferencesService.isFirstTime();
    if (isFirstTime != null && !isFirstTime) {
      _preferencesService.setIsFirstTime(false);
      return false;
    } else {
      _preferencesService.setIsFirstTime(false);
      return true;
    }
  }

  bool isAnonymous() => _preferencesService.anonymousUserExists();

  setAnonymousUser() => _preferencesService.setAnonymousUser();

  deleteAnonymousUser() => _preferencesService.removeAnonymousUser();

  setUserData(String json) => _preferencesService.setUserData(json);

  deleteUserData() => _preferencesService.deleteUserData();

  bool isDeviceRemembered() => _preferencesService.getDeviceExists();

  bool isPasswordRemembered() => _preferencesService.isPasswordRemembered();

  clearAllPrefs() async => await _preferencesService.clearAllPrefs();

  clearUserPrefs() => setManual();

  setAutoPassword(String deviceId) {
    _saveDevice(deviceId);
    _savePassword(
        password.value); // actually call the internal valuestream here
    _connectionRx.addEvent(ConnectionSettings.AutoPassword);
  }

  setAutoConnect(String deviceId) {
    _saveDevice(deviceId);
    removePassword();
    _connectionRx.addEvent(ConnectionSettings.AutoConnect);
  }

  setManual() {
    _removeDeviceId();
    _connectionRx.addEvent((ConnectionSettings.Manual));
  }

  _saveDevice(String deviceId) => _preferencesService.saveDeviceId(deviceId);

  _savePassword(String password) => _preferencesService.savePassword(password);

  removePassword() => _preferencesService.removePasswordRemembrance();

  _removeDeviceId() => _preferencesService.removeDeviceId();

  String getOptionalDeviceId() => _preferencesService.getOptionalDevice();

  String getPassword() => _preferencesService.getOptionalPassword();

  ValueStream<String> get password => _passwordRx.stream;

  Stream<ConnectionSettings> get connectionSettingsChanged =>
      _connectionRx.stream;

  Function(String) get setPassword => _passwordRx.addEvent;

  dispose() {
    _passwordRx.dispose();
    _connectionRx.dispose();
  }
}

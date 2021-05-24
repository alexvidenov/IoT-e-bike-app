import 'package:ble_app/src/blocs/base/RxObject.dart';
import 'package:ble_app/src/blocs/prefs/sharedPrefsService.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

enum ConnectionSettings { Manual, AutoConnect, AutoPassword }

@lazySingleton
class SettingsBloc {
  final _passwordRx = RxObject<String>();
  final _connectionRx = RxObject<ConnectionSettings>();

  final SharedPrefsService _preferencesService;

  SettingsBloc(this._preferencesService);

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

  bool isDeviceRemembered() => _preferencesService.getDeviceExists();

  bool isPasswordRemembered() => _preferencesService.isPasswordRemembered();

  Future<void> clearAllPrefs() async =>
      await _preferencesService.clearAllPrefs();

  void clearUserPrefs() => setManual();

  void setAutoPassword(String deviceId) {
    _saveDevice(deviceId);
    _savePassword(password.value);
    _connectionRx.addEvent(ConnectionSettings.AutoPassword);
  }

  void setAutoConnect(String deviceId) {
    _saveDevice(deviceId);
    removePassword();
    _connectionRx.addEvent(ConnectionSettings.AutoConnect);
  }

  void setManual() {
    _removeDeviceId();
    _connectionRx.addEvent((ConnectionSettings.Manual));
  }

  void _saveDevice(String deviceId) =>
      _preferencesService.saveDeviceId(deviceId);

  void _savePassword(String password) =>
      _preferencesService.savePassword(password);

  void removePassword() => _preferencesService.removePasswordRemembrance();

  void _removeDeviceId() => _preferencesService.removeDeviceId();

  String getOptionalDeviceId() => _preferencesService.getOptionalDevice();

  String getPassword() => _preferencesService.getOptionalPassword();

  ValueStream<String> get password => _passwordRx.stream;

  Stream<ConnectionSettings> get connectionSettingsChanged =>
      _connectionRx.stream;

  Function(String) get setPassword => _passwordRx.addEvent;

  void dispose() {
    _passwordRx.dispose();
    _connectionRx.dispose();
  }
}

import 'package:ble_app/src/blocs/sharedPrefsService.dart';
import 'package:ble_app/src/screens/settings/settingsPage.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class SettingsBloc {
  final _passwordController = BehaviorSubject<String>();

  final _connectionSettingsController = BehaviorSubject<ConnectionSettings>();

  final SharedPrefsService _preferencesService;

  SettingsBloc(this._preferencesService);

  String getUserData() => _preferencesService.userData() ?? 'empty';

  void setUserData(String json) => _preferencesService.setUserData(json);

  void deleteUserData() => _preferencesService.deleteUserData();

  bool isDeviceRemembered() => _preferencesService.getDeviceExists();

  bool isPasswordRemembered() => _preferencesService.isPasswordRemembered();

  void clearPrefs() => setManual();

  void setAutoPassword(String deviceId) {
    _saveDevice(deviceId);
    _savePassword(
        password.value); // actually call the internal valuestream here
    setConnectionSetting(ConnectionSettings.AutoPassword);
  }

  void setAutoconnect(String deviceId) {
    _saveDevice(deviceId);
    removePassword();
    setConnectionSetting(ConnectionSettings.AutoConnect);
  }

  void setManual() {
    _removeDeviceId();
    setConnectionSetting(ConnectionSettings.Manual);
  }

  _saveDevice(String deviceId) => _preferencesService.saveDeviceId(deviceId);

  _savePassword(String password) => _preferencesService.savePassword(password);

  void removePassword() => _preferencesService.removePasswordRemembrance();

  void _removeDeviceId() => _preferencesService.removeDeviceId();

  String getOptionalDeviceId() => _preferencesService.getOptionalDevice();

  String getPassword() => _preferencesService.getOptionalPassword();

  ValueStream<String> get password => _passwordController.stream;

  Stream<ConnectionSettings> get connectionSettingsChanged =>
      _connectionSettingsController.stream;

  Sink<String> get _changePassword => _passwordController.sink;

  Sink<ConnectionSettings> get _changeConnectionSettings =>
      _connectionSettingsController.sink;

  Function(String) get setPassword => _changePassword.add;

  Function(ConnectionSettings) get setConnectionSetting =>
      _changeConnectionSettings.add;

  dispose() {
    _passwordController.close();
    _connectionSettingsController.close();
  }
}

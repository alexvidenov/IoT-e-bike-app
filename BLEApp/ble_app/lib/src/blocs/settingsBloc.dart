import 'package:ble_app/src/blocs/sharedPrefsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/settingsPage.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  final _passwordController = BehaviorSubject<String>();

  final _connectionSettingsController = BehaviorSubject<ConnectionSettings>();

  SharedPrefsService _preferencesService;

  SettingsBloc() : this._preferencesService = locator<SharedPrefsService>();

  bool isDeviceRemembered() => _preferencesService.getDeviceExists();

  bool isPasswordRemembered() => _preferencesService.isPasswordRemembered();

  Future clearAllPrefs() async => await _preferencesService.clearAllPrefs();

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

  _savePassword(String password) {
    _preferencesService.savePassword(password);
  }

  void removePassword() {
    _preferencesService.removePasswordRemembrance();
  }

  void _removeDeviceId() {
    _preferencesService.removeDeviceId();
  }

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

  void dispose() {
    _passwordController.close();
    _connectionSettingsController.close();
  }
}

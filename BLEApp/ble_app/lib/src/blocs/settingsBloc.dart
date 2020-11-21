import 'package:ble_app/src/blocs/sharedPrefsBloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  final _passwordController = BehaviorSubject<String>();
  final _deviceRememberedController = BehaviorSubject<bool>();
  final _passwordRememberedController = BehaviorSubject<bool>();

  final _preferencesService = GetIt.I<SharedPrefsService>();

  bool isDeviceRemembered() => _preferencesService.getDeviceExists();

  bool isPasswordRemembered() => _preferencesService.isPasswordRemembered();

  void saveDeviceId(String deviceId) {
    _preferencesService
        .saveDeviceId(deviceId)
        .then((value) => setDeviceExists(true));
  }

  void removeDeviceId() {
    _preferencesService.removeDeviceId();
    setDeviceExists(false);
  }

  void savePassword(String password) {
    _preferencesService
        .savePassword(password)
        .then((value) => setPasswordExists(true));
  }

  void removePassword() {
    _preferencesService.removePasswordRemembrance();
    setPasswordExists(false);
  }

  String getPassword() => _preferencesService.getOptionalPassword();

  ValueStream<String> get password => _passwordController.stream;
  Stream<bool> get deviceExists => _deviceRememberedController.stream;
  Stream<bool> get passwordExists => _passwordRememberedController.stream;

  Sink<String> get _changePassword => _passwordController.sink;
  Sink<bool> get _changeDeviceExists => _deviceRememberedController.sink;
  Sink<bool> get _changePasswordExists => _passwordRememberedController.sink;

  Function(String) get setPassword => _changePassword.add;
  Function(bool) get setDeviceExists => _changeDeviceExists.add;
  Function(bool) get setPasswordExists => _changePasswordExists.add;

  void dispose() {
    _passwordController.close();
    _deviceRememberedController.close();
    _passwordRememberedController.close();
  }
}

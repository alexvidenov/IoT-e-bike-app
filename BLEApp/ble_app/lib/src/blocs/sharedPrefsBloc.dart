part of bloc;

@singleton
class SharedPrefsService {
  static SharedPrefsService _instance;

  static SharedPreferences _preferences;

  @factoryMethod
  static Future<SharedPrefsService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPrefsService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  dynamic _getPrefs(String key) => _preferences.get(key);

  Future _removePrefs(String key) async => await _preferences.remove(key);

  Future clearAllPrefs() async => await _preferences.clear();

  Future<void> _savePrefs<T>(String key, T value) async {
    if (value is String) {
      await _preferences.setString(key, value);
    }
    if (value is bool) {
      await _preferences.setBool(key, value);
    }
    if (value is int) {
      await _preferences.setInt(key, value);
    }
    if (value is double) {
      await _preferences.setDouble(key, value);
    }
  }

  String userData() => _getPrefs(PrefsKeys.USER_DATA);

  setUserData(String json) => _savePrefs(PrefsKeys.USER_DATA, json);

  Future<void> deleteUserData() async =>
      await _preferences.remove(PrefsKeys.USER_DATA);

  _setDeviceExists(bool deviceExists) =>
      _savePrefs(PrefsKeys.DEVICE_EXISTS, deviceExists);

  _setPasswordRemembered(bool passwordRemembered) =>
      _savePrefs(PrefsKeys.REMEMBER_PASSWORD, passwordRemembered);

  bool getDeviceExists() => _getPrefs(PrefsKeys.DEVICE_EXISTS) ?? false;

  bool isPasswordRemembered() =>
      _getPrefs(PrefsKeys.REMEMBER_PASSWORD) ?? false;

  Future<void> saveDeviceId(String id) async =>
      _savePrefs(PrefsKeys.DEVICE_ID, id).then((_) => _setDeviceExists(true));

  Future<void> savePassword(String password) async =>
      _savePrefs(PrefsKeys.PASSWORD, password)
          .then((value) => _setPasswordRemembered(true));

  removeDeviceId() {
    _removePrefs(PrefsKeys.DEVICE_ID).then((value) => _setDeviceExists(false));
    removePasswordRemembrance();
  }

  removePasswordRemembrance() => _removePrefs(PrefsKeys.PASSWORD)
      .then((value) => _setPasswordRemembered(false));

  String getOptionalDevice() => _getPrefs(PrefsKeys.DEVICE_ID) ?? 'empty';

  String getOptionalPassword() => _getPrefs(PrefsKeys.PASSWORD) ?? 'empty';
}

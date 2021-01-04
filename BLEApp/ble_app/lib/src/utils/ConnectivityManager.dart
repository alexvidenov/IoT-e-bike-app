import 'package:connectivity/connectivity.dart';

abstract class ConnectivityManager {
  static Future<bool> isOnline() async {
    final connectivity = await (Connectivity().checkConnectivity());
    switch (connectivity) {
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.none:
        return false;
    }
    return true;
  }
}

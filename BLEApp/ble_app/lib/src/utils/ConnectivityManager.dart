import 'package:connectivity/connectivity.dart';

abstract class ConnectivityManager {
  static Future<bool> isOnline() async {
    switch (await (Connectivity().checkConnectivity())) {
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

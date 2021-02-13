import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/SembastDatabase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

mixin LocationCachingManager on CurrentContext {
  final _sembastDB = $<SembastDatabase>();

  void createCoordinatesFile(String fileName) {
    _sembastDB.createRouteFile(curUserId, curDeviceId, fileName);
  }

  void updateCachedLocation(String fileName, List<LatLng> coordinates) {
    _sembastDB.updateCoordinatesRouteFile(
        curUserId, curDeviceId, fileName, coordinates: coordinates);
  }
}
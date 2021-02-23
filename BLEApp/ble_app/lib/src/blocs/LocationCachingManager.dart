import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/SembastDatabase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteFileModel {
  final String name;
  final String startedAt;
  final String finishedAt;
  final double lengthInKilometers; // TODO: calculate these fields
  final double wastedPowerInWh;
  final List<LatLng> coordinates;

  const RouteFileModel(
      {this.name,
      this.coordinates,
      this.startedAt,
      this.finishedAt,
      this.lengthInKilometers,
      this.wastedPowerInWh});
}

mixin LocationCachingManager on CurrentContext {
  final _sembastDB = $<SembastDatabase>();

  void createCoordinatesFile(String initialTimeStamp) {
    _sembastDB.createRouteFile(curUserId, curDeviceId, initialTimeStamp);
  }

  void updateCachedLocation(
      String fileName, List<LatLng> coordinates, String finishedAt) {
    _sembastDB.updateCoordinatesRouteFile(curUserId, curDeviceId, fileName,
        coordinates: coordinates, finishedAt: finishedAt);
  }

  void renameCachedLocation(String fileTimeStamp, String newFileName) {
    _sembastDB.renameRecording(
        curUserId, curDeviceId, fileTimeStamp, newFileName);
  }

  Future<Stream<List<RouteFileModel>>> get cachedRoutesStream =>
      _sembastDB.cachedRoutesStream(curUserId, curDeviceId);

  Future<void> openRoutesDB() => _sembastDB.openRoutesDB();
}

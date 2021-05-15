import 'package:ble_app/src/blocs/mixins/CurrentContext.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/routeFileModel.dart';
import 'package:ble_app/src/persistence/SembastDatabase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

mixin LocationCachingManager on CurrentContext {
  final _sembastDB = $<SembastDatabase>();

  void createCoordinatesFile(String initialTimeStamp) {
    _sembastDB.createRouteFile(curUserId, curDeviceId, initialTimeStamp);
  }

  void updateWattPerHour(String fileName, double watts) =>
      _sembastDB.updateWattPerHour(fileName, wattsPerHour: watts);

  Future<RouteFileModel> updateCachedLocation(String fileName,
      List<LatLng> coordinates, String finishedAt, num length) {
    return _sembastDB.updateCoordinatesRouteFile(
        curUserId, curDeviceId, fileName,
        coordinates: coordinates, finishedAt: finishedAt, length: length);
  }

  Future<RouteFileModel> renameCachedLocation(
          String fileTimeStamp, String newFileName) async =>
      await _sembastDB.renameRecording(
          curUserId, curDeviceId, fileTimeStamp, newFileName);

  Future deleteRouteFile(String fileTimeStamp) =>
      _sembastDB.deleteRecording(fileTimeStamp);

  Future<Stream<List<RouteFileModel>>> get cachedRoutesStream =>
      _sembastDB.cachedRoutesStream(curUserId, curDeviceId);

  Future<void> openRoutesDB() => _sembastDB.openRoutesDB();
}

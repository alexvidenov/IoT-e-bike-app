import 'dart:async';

import 'package:ble_app/src/blocs/mixins/CurrentContext.dart';
import 'package:ble_app/src/modules/dataClasses/routeFileModel.dart';
import 'package:ble_app/src/utils/locationUtils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:jiffy/jiffy.dart';

import '../../persistence/cachingManagers/LocationCachingManager.dart';
import '../base/RxObject.dart';

@lazySingleton
class LocationTracker with CurrentContext, LocationCachingManager {
  final isRecordingRx = RxObject<bool>();

  Timer _distanceTimer;

  double _memoizedDistance =
      0; // Should refresh that value on disconnect. Optional  (make it a setting or some shit)

  final distanceRx = RxObject<double>();

  final isShowingCachedRoute = RxObject<bool>();

  LocationTracker() {
    isRecordingRx.addEvent(false);
    isShowingCachedRoute.addEvent(false);
    print("SETTING UP ROUTES");
    _distanceTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _memoizedDistance += SphericalUtil.computeLength(_calculatedCoordinates);
      _calculatedCoordinates.clear();
      distanceRx.addEvent(_memoizedDistance);
    });
  }

  Future<void> setupRoutesDB() async => await openRoutesDB();

  final List<LatLng> _calculatedCoordinates = [];

  List<LatLng> get calculatedCoords => _calculatedCoordinates;

  final List<LatLng> _visibleCoordinates = [];

  List<LatLng> get visibleCoords => _visibleCoordinates;

  final routesRx = RxObject<List<RouteFileModel>>();

  String _currentFilename;

  void startRecording() {
    isRecordingRx.addEvent(true);
    _currentFilename = Jiffy().yMMMdjm;
    createCoordinatesFile(_currentFilename);
  }

  Future<RouteFileModel> stopRecording() {
    isRecordingRx.addEvent(false);
    _visibleCoordinates.clear();
    return updateCachedLocation(
        _currentFilename,
        _visibleCoordinates,
        Jiffy().yMMMdjm,
        num.parse((SphericalUtil.computeLength(visibleCoords) / 1000)
            .toStringAsFixed(3)));
  }

  Future<RouteFileModel> renameFile(String fileName,
      {String previousTimeStamp}) async {
    final routeFile = await renameCachedLocation(
        previousTimeStamp ?? _currentFilename, fileName);
    return routeFile;
  }

  void addWattPerHourForRoute(double watts) =>
      updateWattPerHour(_currentFilename, watts);

  Future deleteFile(String timeStamp) => deleteRouteFile(timeStamp);

  void addVisibleCoords(double latitude, double longitude) =>
      _visibleCoordinates.add(LatLng(latitude, longitude));

  void addCoordsForCalculate(double latitude, double longitude) =>
      _calculatedCoordinates.add(LatLng(latitude, longitude));

  void loadCachedRoutes() =>
      cachedRoutesStream.then((stream) => stream.listen((event) {
            print('Cached routes event : $event');
            routesRx.addEvent(event);
          }));

  void loadCoordinates(List<LatLng> coords) {
    print('LOADING COORDINATES');
    _visibleCoordinates.clear();
    _visibleCoordinates.addAll(coords);
    isShowingCachedRoute.addEvent(true);
  }

  void clearLoadedCoordinates() {
    _visibleCoordinates.clear();
    isShowingCachedRoute.addEvent(false);
  }

  void disposeTimer() => _distanceTimer.cancel();
}

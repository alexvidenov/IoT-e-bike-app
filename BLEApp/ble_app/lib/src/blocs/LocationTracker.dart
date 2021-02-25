import 'dart:async';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:jiffy/jiffy.dart';

import 'LocationCachingManager.dart';
import 'RxObject.dart';

import 'dart:math';

class MathUtil {
  static num toRadians(num degrees) => degrees / 180.0 * pi;

  static num hav(num x) => sin(x * 0.5) * sin(x * 0.5);

  static num arcHav(num x) => 2 * asin(sqrt(x));

  static num havDistance(num lat1, num lat2, num dLng) =>
      hav(lat1 - lat2) + hav(dLng) * cos(lat1) * cos(lat2);
}

class SphericalUtil {
  static const num earthRadius = 6371009.0;

  static num computeLength(List<LatLng> path) {
    if (path.length < 2) {
      return 0;
    }

    final prev = path.first;
    var prevLat = MathUtil.toRadians(prev.latitude);
    var prevLng = MathUtil.toRadians(prev.longitude);

    final length = path.fold<num>(0.0, (value, point) {
      final lat = MathUtil.toRadians(point.latitude);
      final lng = MathUtil.toRadians(point.longitude);
      value += distanceRadians(prevLat, prevLng, lat, lng);
      prevLat = lat;
      prevLng = lng;

      return value;
    });

    return length * earthRadius;
  }

  static num distanceRadians(num lat1, num lng1, num lat2, num lng2) =>
      MathUtil.arcHav(MathUtil.havDistance(lat1, lat2, lng1 - lng2));
}

@lazySingleton
class LocationTracker with CurrentContext, LocationCachingManager {
  final isRecordingRx = RxObject<bool>();

  double _memoizedDistance =
      0; // Should refresh that value on disconnect. Optional  (make it a setting or some shit)

  final distanceRx = RxObject<double>();

  final isShowingCachedRoute = RxObject<bool>();

  LocationTracker() {
    isRecordingRx.addEvent(false);
    isShowingCachedRoute.addEvent(false);
    _setupRoutes();
    Timer.periodic(Duration(seconds: 30), (timer) {
      _memoizedDistance += SphericalUtil.computeLength(_calculatedCoordinates);
      _calculatedCoordinates.clear();
      distanceRx.addEvent(_memoizedDistance);
    });
  }

  Future<void> _setupRoutes() async => await openRoutesDB();

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

  void stopRecording() {
    isRecordingRx.addEvent(false);
    updateCachedLocation(
        _currentFilename,
        _visibleCoordinates,
        Jiffy().yMMMdjm,
        num.parse((SphericalUtil.computeLength(visibleCoords) / 1000)
            .toStringAsFixed(3)));
    _visibleCoordinates.clear();
  }

  void renameFile(String fileName) =>
      renameCachedLocation(_currentFilename, fileName);

  void addVisibleCoords(double latitude, double longitude) =>
      _visibleCoordinates.add(LatLng(latitude, longitude));

  void addCoordsForCalculate(double latitude, double longitude) =>
      _calculatedCoordinates.add(LatLng(latitude, longitude));

  void loadCoordinates(List<LatLng> coords) {
    print('LOADING COORDINATES');
    _visibleCoordinates.addAll(coords);
    isShowingCachedRoute.addEvent(true);
  }

  void clearLoadedCoordinates() {
    _visibleCoordinates.clear();
    isShowingCachedRoute.addEvent(false);
  }
}

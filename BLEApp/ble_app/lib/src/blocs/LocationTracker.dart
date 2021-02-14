import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import 'LocationCachingManager.dart';
import 'RxObject.dart';

@lazySingleton
class LocationTracker with CurrentContext, LocationCachingManager {
  final isRecordingRx = RxObject<bool>();

  final isShowingCachedRoute = RxObject<bool>();

  LocationTracker() {
    isRecordingRx.addEvent(false);
    isShowingCachedRoute.addEvent(false);
  }

  final List<LatLng> _coordinates = [];

  List<LatLng> get coords => _coordinates;

  final routesRx = RxObject<List<RouteFileModel>>();

  DateTime _currentFilename;

  void startRecording() {
    isRecordingRx.addEvent(true);
    _currentFilename = DateTime.now();
    createCoordinatesFile(_currentFilename.toString());
  }

  void stopRecording() {
    isRecordingRx.addEvent(false);
    updateCachedLocation(_currentFilename.toString(), _coordinates);
    _coordinates.clear();
  }

  void addCoords(double latitude, double longitude) =>
      _coordinates.add(LatLng(latitude, longitude));

  void loadCoordinates(List<LatLng> coords) {
    print('LOADING COORDINATES');
    _coordinates.addAll(coords);
    isShowingCachedRoute.addEvent(true);
  }

  void clearLoadedCoordinates() {
    _coordinates.clear();
    isShowingCachedRoute.addEvent(false);
  }

  void renameFile(String fileName) =>
      renameCachedLocation(_currentFilename.toString(), fileName);
}

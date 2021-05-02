import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/LocationTracker.dart';
import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'LocationCachingManager.dart';

class LocationState {
  final LocationData locationData;
  final Set<Polyline> polylines;

  const LocationState(this.locationData, {this.polylines});
}

@injectable
class LocationBloc extends Bloc<LocationState, LocationData> {
  final Location _location = Location();

  LocationTracker _locationTracker;

  LocationBloc(this._locationTracker);

  GoogleMapController _controller;

  bool _isOffline = false;

  static final CameraPosition _initialLocation = CameraPosition(
    // prolly save the latest seen location in shared prefs(aka in dispose())
    target: LatLng(37.42796133580664, -122.085749655962),
    // probably don't have initial location, but dynamically load it
    zoom: 14.4746,
  );

  ValueStream<List<RouteFileModel>> get routes =>
      _locationTracker.routesRx.stream;

  final speedRx = RxObject<double>();

  Stream<bool> get isRecording => _locationTracker.isRecordingRx.stream;

  Stream<bool> get isShowingRoute =>
      _locationTracker.isShowingCachedRoute.stream;

  Stream<double> get kilometres => _locationTracker.distanceRx.stream;

  CameraPosition get initialLocation => _initialLocation;

  set controller(GoogleMapController controller) =>
      this._controller = controller;

  set isOffline(bool isOffline) => this._isOffline = isOffline;

  Circle generateNewCircle(LocationData locationData) => Circle(
      circleId: CircleId("currentPositionCircle"),
      radius: locationData?.accuracy,
      zIndex: 1,
      strokeColor: Colors.blue,
      center: LatLng(locationData?.latitude, locationData?.longitude),
      fillColor: Colors.blue.withAlpha(70));

  Marker generateNewMarker(LocationData locationData) => Marker(
        markerId: MarkerId("currentPositionMarker"),
        position: LatLng(locationData?.latitude, locationData?.longitude),
        rotation: locationData?.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
      );

  @override
  create() async {
    logger.wtf('CREATING IN LOCATION BLOC');
    try {
      final location = await _location.getLocation();

      print("ADDING CURRENT LOCATION");

      addEvent(LocationState(location));

      streamSubscription = _location.onLocationChanged.listen((locData) {
        if (!_isOffline) {
          print('ON LOCATION CHANGED CALLED');
          final lat = locData.latitude;
          final long = locData.longitude;
          speedRx.addEvent(locData
              .speed); // FIXME: don't do anything if this is not bigger than 2.0
          _locationTracker.addCoordsForCalculate(lat, long);
          if (_controller != null &&
              !_locationTracker.isShowingCachedRoute.value) {
            _controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    bearing: 192.8334901395799,
                    target: LatLng(lat, long),
                    tilt: 0,
                    zoom: 18.00)));
          }
          final shouldShowPolyline = _locationTracker.isRecordingRx.value ||
              _locationTracker.isShowingCachedRoute.value;
          if (_locationTracker.isRecordingRx.value) {
            print('ADDING COORDINATES');
            _locationTracker.addVisibleCoords(lat, long);
          }
          addEvent(LocationState(
              locData, // FIXME online -> offline => can't add new events
              polylines: Set.of(shouldShowPolyline
                  ? [
                      Polyline(
                          polylineId: PolylineId('firstRoute'),
                          points: _locationTracker.visibleCoords,
                          width: 8)
                    ]
                  : [])));
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // add event that says that the permission is denied
        debugPrint("Permission Denied");
      }
    }
  }

  void startRecording() => _locationTracker.startRecording();

  void stopRecording() => _locationTracker.stopRecording();

  void renameFile(String fileName) => _locationTracker.renameFile(fileName);

  void loadCachedRoute(String fileTimeStamp) {
    final coords = routes.value
        .firstWhere((route) => route.startedAt == fileTimeStamp)
        .coordinates;
    if (coords.isNotEmpty) {
      _locationTracker.loadCoordinates(coords);
      addEvent(LocationState(null, // NULL WON'T WORK HERE
          polylines: Set.of([
            Polyline(
                polylineId: PolylineId('firstRoute'),
                points: _locationTracker.visibleCoords,
                width: 8)
          ])));
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 192.8334901395799,
          target: coords.first,
          tilt: 0,
          zoom: 18.00)));
    }
  }

  void removeVisibleCachedRoute() => _locationTracker.clearLoadedCoordinates();

  void loadCachedRoutes() => _locationTracker
      .setupRoutesDB()
      .then((_) => _locationTracker.loadCachedRoutes());

  @override
  resume() {
    logger.wtf('RESUMING IN LOCATION BLOC');
    super.resume();
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Location Bloc');
    removeVisibleCachedRoute();
    super.dispose();
  }
}

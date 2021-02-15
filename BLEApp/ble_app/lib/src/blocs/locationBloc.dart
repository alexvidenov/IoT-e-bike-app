import 'package:ble_app/src/blocs/LocationTracker.dart';
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

  static final CameraPosition _initialLocation = CameraPosition(
    // prolly save the latest seen location in shared prefs(aka in dispose())
    target: LatLng(37.42796133580664, -122.085749655962),
    // probably don't have initial location, but dynamically load it
    zoom: 14.4746,
  );

  ValueStream<List<RouteFileModel>> get routes =>
      _locationTracker.routesRx.stream;

  Stream<bool> get isRecording => _locationTracker.isRecordingRx.stream;

  Stream<bool> get isShowingRoute =>
      _locationTracker.isShowingCachedRoute.stream;

  CameraPosition get initialLocation => _initialLocation;

  set controller(GoogleMapController controller) =>
      this._controller = controller;

  Circle generateNewCircle(LocationData locationData) => Circle(
      circleId: CircleId("currentPositionCircle"),
      radius: locationData.accuracy,
      zIndex: 1,
      strokeColor: Colors.blue,
      center: LatLng(locationData.latitude, locationData.longitude),
      fillColor: Colors.blue.withAlpha(70));

  Marker generateNewMarker(LocationData locationData) => Marker(
        markerId: MarkerId("currentPositionMarker"),
        position: LatLng(locationData.latitude, locationData.longitude),
        rotation: locationData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
      );

  @override
  create() async {
    try {
      final location = await _location.getLocation();

      addEvent(LocationState(location));

      if (streamSubscription != null) streamSubscription.cancel();

      streamSubscription = _location.onLocationChanged.listen((locData) {
        final lat = locData.latitude;
        final long = locData.longitude;
        if (_controller != null) {
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
          _locationTracker.addCoords(lat, long);
        }
        addEvent(LocationState(locData,
            polylines: Set.of(shouldShowPolyline
                ? [
                    Polyline(
                        polylineId: PolylineId('firstRoute'),
                        points: _locationTracker.coords,
                        width: 8)
                  ]
                : [])));
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

  void loadCachedRoute(String fileTimeStamp) =>
      _locationTracker.loadCoordinates(routes.value
          .firstWhere((route) => route.startedAt == fileTimeStamp)
          .coordinates);

  void removeCachedRoute() => _locationTracker.clearLoadedCoordinates();

  void loadCachedRoutes() => _locationTracker.cachedRoutesStream
      .then((stream) => stream.listen((event) {
            print('Cached routes event : $event');
            _locationTracker.routesRx.addEvent(event);
          }));
}

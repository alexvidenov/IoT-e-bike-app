import 'package:ble_app/src/blocs/ContextAwareBloc.dart';
import 'package:ble_app/src/blocs/LocationCachingManager.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/RxObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

part 'blocExtensions/TrackLocation.dart';

class LocationState {
  final LocationData locationData;
  final Set<Polyline> polylines;

  const LocationState(this.locationData, {this.polylines});
}

@lazySingleton // FIXME: the fact that this is a singleton fucks up the disposal of the stream here
class LocationBloc extends ContextAwareBloc<LocationState, LocationData>
    with LocationCachingManager {
  final Location _location = Location();

  GoogleMapController _controller;

  static final CameraPosition _initialLocation = CameraPosition(
    // prolly save the latest seen location in shared prefs(aka in dispose())
    target: LatLng(37.42796133580664, -122.085749655962),
    // probably don't have initial location, but dynamically load it
    zoom: 14.4746,
  );

  final List<LatLng> _coordinates = [];

  final isRecordingRx = RxObject<bool>();

  DateTime _currentFilename;

  CameraPosition get initialLocation => _initialLocation;

  set controller(GoogleMapController controller) =>
      this._controller = controller;

  void startRecording() {
    isRecordingRx.addEvent(true);
    _currentFilename = DateTime.now();
    createCoordinatesFile(_currentFilename.toString());
  }

  void stopRecording() {
    isRecordingRx.addEvent(false);
    updateCachedLocation(_currentFilename.toString(), _coordinates);
    _coordinates.clear();
    // optionally rename this
  }

  Circle generateNewCircle(LocationData locationData) => Circle(
      circleId: CircleId("car"),
      radius: locationData.accuracy,
      zIndex: 1,
      strokeColor: Colors.blue,
      center: LatLng(locationData.latitude, locationData.longitude),
      fillColor: Colors.blue.withAlpha(70));

  Marker generateNewMarker(LocationData locationData) => Marker(
        markerId: MarkerId("home"),
        position: LatLng(locationData.latitude, locationData.longitude),
        rotation: locationData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
      );

  @override
  create() => _startTrackingLocation();

  @override
  dispose() {
    logger.wtf('Closing stream in Location Bloc');
    if (isRecordingRx.value) {
      // save the routes
    }
    super.dispose();
  }
}

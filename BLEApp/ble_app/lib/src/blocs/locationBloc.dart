import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/persistence/SembastDatabase.dart';
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

@injectable
class LocationBloc extends Bloc<LocationState, LocationData> with CurrentContext {
  final Location _location = Location();
  final SembastDatabase _sembastDatabase;

  GoogleMapController _controller;

  LocationBloc(this._sembastDatabase);

  static final CameraPosition _initialLocation = CameraPosition(
    // prolly save the latest seen location in shared prefs(aka in dispose())
    target: LatLng(37.42796133580664,
        -122.085749655962), // probably don't have initial location, but dynami
    zoom: 14.4746,
  );

  final List<LatLng> _coordinates = [];

  get initialLocation => _initialLocation;

  set controller(GoogleMapController controller) =>
      this._controller = controller;

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
        //icon: BitmapDescriptor.fromBytes(imageData) add icon later on, you know
      );

  @override
  create() => _startTrackingLocation();

  @override
  dispose() {
    logger.wtf('Closing stream in Location Bloc');
    super.dispose();
  }
}

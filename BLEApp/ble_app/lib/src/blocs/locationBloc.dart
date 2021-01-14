import 'dart:async';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

part '../extensions/TrackLocation.dart';

@injectable
class LocationBloc extends Bloc<LocationData, LocationData> {
  final Location _location = Location();

  GoogleMapController _controller;

  static final CameraPosition _initialLocation = CameraPosition(
    // prolly save the latest seen location in shared prefs(aka in dispose())
    target: LatLng(37.42796133580664,
        -122.085749655962), // probably don't have initial location, but dynami
    zoom: 14.4746,
  );

  get initialLocation => _initialLocation;

  set controller(GoogleMapController controller) =>
      this._controller = controller;

  generateNewCircle(LocationData locationData) => Circle(
      circleId: CircleId("car"),
      radius: locationData.accuracy,
      zIndex: 1,
      strokeColor: Colors.blue,
      center: LatLng(locationData.latitude, locationData.longitude),
      fillColor: Colors.blue.withAlpha(70));

  generateNewMarker(LocationData locationData) => Marker(
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

  @override
  mapEventToState(LocationData data, EventSink<LocationData> sink) =>
      sink.add(data);
}

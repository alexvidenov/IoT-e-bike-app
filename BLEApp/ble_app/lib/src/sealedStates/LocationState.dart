import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationState {
  final LocationData locationData;
  final Set<Polyline> polylines;

  const LocationState(this.locationData, {this.polylines});
}

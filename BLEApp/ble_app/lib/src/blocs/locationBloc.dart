part of bloc;

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
  void create() => startTrackingLocation();
}


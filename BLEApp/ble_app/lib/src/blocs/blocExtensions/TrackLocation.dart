part of '../locationBloc.dart';

extension TrackLocation on LocationBloc {
  _startTrackingLocation() async {
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
        _coordinates.add(LatLng(lat, long));
        addEvent(LocationState(locData,
            polylines: Set.of([
              Polyline(
                  polylineId: PolylineId('firstRoute'),
                  points: this._coordinates,
                  width: 8)
            ])));
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // add event that says that the permission is denied
        debugPrint("Permission Denied");
      }
    }
  }
}

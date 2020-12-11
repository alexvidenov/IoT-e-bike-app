part of bloc;

extension TrackLocation on LocationBloc {
  void startTrackingLocation() async {
    try {
      var location = await _location.getLocation();

      addEvent(location);

      if (streamSubscription != null) {
        streamSubscription.cancel();
      }

      streamSubscription = _location.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
        }
        addEvent(newLocalData);
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // add event that says that the permission is denied
        debugPrint("Permission Denied");
      }
    }
  }
}
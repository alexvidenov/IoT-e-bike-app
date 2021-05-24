import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/WattCollector.dart';
import 'package:ble_app/src/blocs/location/LocationTracker.dart';
import 'package:ble_app/src/blocs/base/RxObject.dart';
import 'package:ble_app/src/modules/dataClasses/routeFileModel.dart';
import 'package:ble_app/src/screens/base/PageViewWidget.dart';
import 'package:ble_app/src/sealedStates/LocationState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:location/location.dart';
import 'package:ble_app/src/blocs/base/bloc.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class LocationBloc extends Bloc<LocationState, LocationData>
    with OnWattHoursCalculated {
  final Location _location = Location();

  OnShouldLockPageViewScroll onShouldLockPageViewScroll;

  final LocationTracker _locationTracker;
  final WattCollector _wattCollector;

  LocationBloc(this._locationTracker, this._wattCollector);

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

  final currentRouteSelected = RxObject<RouteFileModel>();

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
    _wattCollector.onWattHoursCalculated = this;
    try {
      final location = await _location.getLocation();

      print("ADDING CURRENT LOCATION");

      addEvent(LocationState(location));

      streamSubscription = _location.onLocationChanged.listen((locData) {
        if (!_isOffline) {
          print('ON LOCATION CHANGED CALLED');
          final lat = locData.latitude;
          final long = locData.longitude;
          final speed = locData.speed * 3.6; // km / h
          print('SPEED RIGHT IS BRO: $speed');
          if (speed >= 4.0) {
            // don't add up coords if speed is not more than 4 km/h.
            _locationTracker.addCoordsForCalculate(lat, long);
            speedRx.addEvent(speed);
          } else {
            speedRx.addEvent(0.0);
          }
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
          addEvent(LocationState(locData,
              polylines: Set.of(shouldShowPolyline
                  ? [
                      Polyline(
                          polylineId: PolylineId('firstRoute'),
                          points: _locationTracker.visibleCoords,
                          width: 8)
                    ]
                  : const [])));
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // add event that says that the permission is denied
        debugPrint("Permission Denied");
      }
    }
  }

  void startRecording() {
    _locationTracker.startRecording();
    _wattCollector.startTrack();
  }

  void stopRecording() {
    _locationTracker.stopRecording().then((model) {
      final started =
          Jiffy(DateFormat.yMMMd().add_jm().parse(model.startedAt)).dateTime;
      final finished =
          Jiffy(DateFormat.yMMMd().add_jm().parse(model.finishedAt)).dateTime;
      final Duration trackDuration = finished.difference(started);
      _wattCollector.finishTrack(trackDuration.inMinutes.toDouble());
    });
  }

  Future renameFile(String fileName, {String previousTimeStamp}) =>
      _locationTracker
          .renameFile(fileName, previousTimeStamp: previousTimeStamp)
          .then((renamed) {
        if (currentRouteSelected?.value?.startedAt == renamed.startedAt) {
          currentRouteSelected.addEvent(renamed);
        }
      });

  Future deleteFile(String timeStamp) async =>
      await _locationTracker.deleteFile(timeStamp);

  void loadCachedRoute(String fileTimeStamp) {
    final file =
        routes.value.firstWhere((route) => route.startedAt == fileTimeStamp);
    currentRouteSelected.addEvent(file);
    final coords = file.coordinates;
    if (coords.isNotEmpty) {
      onShouldLockPageViewScroll?.shouldScroll(false);
      _locationTracker.loadCoordinates(coords);
      addEvent(LocationState(null,
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

  void removeVisibleCachedRoute({bool calledFromDispose = false}) {
    _locationTracker.clearLoadedCoordinates();
    currentRouteSelected.addEvent(null);
    if (!calledFromDispose) onShouldLockPageViewScroll?.shouldScroll(true);
    addEvent(LocationState(null, polylines: Set.of([])));
  }

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
    removeVisibleCachedRoute(calledFromDispose: true);
    _locationTracker.disposeTimer();
    super.dispose();
  }

  @override
  void onWattHoursCalculated(double wattHours) => _locationTracker
      .addWattPerHourForRoute(double.parse(wattHours.toStringAsFixed(2)));
}

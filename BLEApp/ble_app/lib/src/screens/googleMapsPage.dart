import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final LocationBloc _locationBloc;

  const MapPage(Key key, this._locationBloc) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    widget._locationBloc.startTrackingLocation();
  }

  @override
  void dispose() {
    super.dispose();
    widget._locationBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocationData>(
        stream: widget._locationBloc.stream,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var marker = widget._locationBloc.generateNewMarker(snapshot.data);
            var circle = widget._locationBloc.generateNewCircle(snapshot.data);
            return InkWell(
              onLongPress: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (_) => false),
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: widget._locationBloc.initialLocation,
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  widget._locationBloc.controller = controller;
                },
              ),
            );
          } else
            return Container();
        });
  }
}

/*
class MapPage extends AppBarWidget {
  final LocationBloc _locationBloc;

  const MapPage(Key key, this._locationBloc) : super(key: key);

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<LocationData>(
        stream: _locationBloc.stream,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var marker = _locationBloc.generateNewMarker(snapshot.data);
            var circle = _locationBloc.generateNewCircle(snapshot.data);
            return InkWell(
              onLongPress: () => Navigator.of(context)
                  .popUntil((ModalRoute.withName('short'))),
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _locationBloc.initialLocation,
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _locationBloc.controller = controller;
                },
              ),
            );
          } else
            return Container();
        });
  }

  @override
  void onCreate() {
    _locationBloc.startTrackingLocation();
  }

  @override
  void onDestroy() {
    _locationBloc.dispose();
  }

  @override
  void onPause() {}

  @override
  void onResume() {}
}
*/

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends RouteAwareWidget {
  final LocationBloc _locationBloc;
  final NavigationBloc _navigationBloc;

  MapPage(LocationBloc locationBloc, this._navigationBloc)
      : this._locationBloc = locationBloc,
        super(bloc: locationBloc);

  @override
  Widget buildWidget(BuildContext context) {
    return StreamBuilder<LocationData>(
        stream: _locationBloc.stream,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final marker = _locationBloc.generateNewMarker(snapshot.data);
            final circle = _locationBloc.generateNewCircle(snapshot.data);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: () => _navigationBloc.returnToFirstRoute(),
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
  void onResume() {
    super.onResume();
    _navigationBloc.addEvent(CurrentPage.Map);
  }
}

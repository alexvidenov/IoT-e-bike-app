import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/screens/abstractVisibleWidget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends VisibleWidget {
  MapPage({@required Key key}) : super(key: key);

  final bloc = GetIt.I<LocationBloc>();

  @override
  Widget buildWidget() => Scaffold(
        body: StreamBuilder<LocationData>(
            stream: bloc.stream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                var marker = bloc.generateNewMarker(snapshot.data);
                var circle = bloc.generateNewCircle(snapshot.data);
                return GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: bloc.initialLocation,
                  markers: Set.of((marker != null) ? [marker] : []),
                  circles: Set.of((circle != null) ? [circle] : []),
                  onMapCreated: (GoogleMapController controller) {
                    bloc.controller = controller;
                  },
                );
              } else
                return Container();
            }),
      );

  @override
  void onCreate() {
    bloc.startTrackingLocation();
  }

  @override
  void onDestroy() {
    bloc.dispose();
  }

  @override
  void onPause() {
    bloc.pauseSubscription();
  }

  @override
  void onResume() {
    bloc.resumeSubscription();
    bloc.startTrackingLocation();
  }
}

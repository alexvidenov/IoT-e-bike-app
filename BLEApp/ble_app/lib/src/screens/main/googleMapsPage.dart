import 'package:ble_app/src/blocs/InnerPageManager.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/mixins/KeepSession.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends RouteAwareWidget<LocationBloc>
    with RouteUtils, KeepSession {
  final LocationBloc _locationBloc;

  MapPage(LocationBloc locationBloc)
      : this._locationBloc = locationBloc,
        super(bloc: locationBloc);

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<LocationState>(
          stream: _locationBloc.stream,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final marker =
                  _locationBloc.generateNewMarker(snapshot.data.locationData);
              final circle =
                  _locationBloc.generateNewCircle(snapshot.data.locationData);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: () => $<InnerPageManager>().openShortStatus(),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _locationBloc.initialLocation,
                  zoomControlsEnabled: false,
                  markers: Set.of((marker != null) ? [marker] : []),
                  circles: Set.of((circle != null) ? [circle] : []),
                  polylines: snapshot.data.polylines ?? Set.of([]),
                  onMapCreated: (controller) =>
                      _locationBloc.controller = controller,
                ),
              );
            } else
              return Container();
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<bool>(
            stream: _locationBloc.isRecordingRx.stream,
            initialData: false,
            builder: (_, snapshot) {
              return FloatingActionButton.extended(
                label: snapshot.data
                    ? Text('Stop recording',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.lightBlue))
                    : Text('Record route',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.lightBlue)),
                icon: Icon(snapshot.data
                    ? Icons.pause_circle_filled_outlined
                    : Icons.add_location_rounded),
                onPressed: () => snapshot.data
                    ? _locationBloc.stopRecording()
                    : _locationBloc.startRecording(),
                heroTag: null,
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton.extended(
            label: Text(
              'View routes',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.lightBlue),
            ),
            icon: Icon(Icons.album_rounded),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) {
                    return DraggableScrollableSheet(
                      expand: false,
                      builder: (_, controller) {
                        return SingleChildScrollView(
                          controller: controller,
                          child: Card(
                            elevation: 12.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            margin: const EdgeInsets.all(0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  BottomSheetHeader(),
                                  const SizedBox(height: 16),
                                  LastRoutesHeader(),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: GridView.count(
                                      physics: ScrollPhysics(),
                                      padding: const EdgeInsets.all(0),
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      shrinkWrap: true,
                                      children: [
                                        ..._locationBloc.routesRx.value
                                            .map((e) => LastRouteView(
                                                  routeName: e.name,
                                                )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  });
            },
            heroTag: null,
          )
        ],
      ),
    );
  }

  @override
  onResume() {
    keepSession(); // necessary for the hardware timers to not pass out after three seconds
    notifyForRoute(CurrentPage.Map);
  }

  @override
  onDestroy() {
    pause();
    super.onDestroy();
  }
}

class BottomSheetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 30,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }
}

class LastRoutesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Saved routes",
            style: TextStyle(fontSize: 22, color: Colors.black45)),
        SizedBox(width: 8),
        Container(
          height: 24,
          width: 24,
          child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black54),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
        ),
      ],
    );
  }
}

class LastRouteView extends StatelessWidget {
  final String routeName;

  const LastRouteView({Key key, this.routeName}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.lightBlueAccent,
        elevation: 12.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.all(0),
        child: InkWell(
          onTap: () => {}, // TODO: handle this
          child: Container(
            width: 150,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(routeName),
                const SizedBox(
                  height: 4.0,
                ),
                Text('Kilometers here'),
                const SizedBox(
                  height: 4.0,
                ),
                Text('W/h here'),
              ],
            ),
          ),
        ),
      );
}

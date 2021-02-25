import 'package:ble_app/src/blocs/LocationCachingManager.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CachedRouteChosenNotification extends Notification {
  final String fileName;

  const CachedRouteChosenNotification(this.fileName);
}

class MapPage extends StatefulWidget {
  final LocationBloc _locationBloc;

  MapPage(this._locationBloc);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  final _saveFileDialogController = TextEditingController();

  void _showDialogToSaveRoute(context) async => await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
            title: Text('Save file as:'),
            content: TextField(
              controller: _saveFileDialogController,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Confirm"),
                onPressed: () {
                  widget._locationBloc
                      .renameFile(_saveFileDialogController.value.text);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ));

  @override
  void initState() {
    super.initState();
    widget._locationBloc.loadCachedRoutes();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(alignment: Alignment.topRight, children: [
          StreamBuilder<bool>(
            stream: widget._locationBloc.isShowingRoute,
            initialData: false,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final value = snapshot.data;
                print('value: $value');
                return snapshot.data
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 40,
                          color: Colors.red,
                        ),
                        color: Colors.red,
                        onPressed: () =>
                            widget._locationBloc.removeCachedRoute(),
                      )
                    : Container();
              } else
                return Container();
            },
          ),
          StreamBuilder<LocationState>(
            stream: widget._locationBloc.stream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final marker = widget._locationBloc
                    .generateNewMarker(snapshot.data.locationData);
                final circle = widget._locationBloc
                    .generateNewCircle(snapshot.data.locationData);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPress: () => {}, // NOTIFICATIONS,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: widget._locationBloc.initialLocation,
                    zoomControlsEnabled: false,
                    markers: Set.of((marker != null) ? [marker] : []),
                    circles: Set.of((circle != null) ? [circle] : []),
                    polylines: snapshot.data.polylines ?? Set.of([]),
                    onMapCreated: (controller) =>
                        widget._locationBloc.controller = controller,
                  ),
                );
              } else
                return Container();
            },
          )
        ]),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder<bool>(
              stream: widget._locationBloc.isRecording,
              initialData: false,
              builder: (_, snapshot) => FloatingActionButton.extended(
                label: snapshot.data
                    ? Text('Stop recording',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue))
                    : Text('Record route',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                icon: Icon(snapshot.data
                    ? Icons.pause_circle_filled_outlined
                    : Icons.add_location_rounded),
                onPressed: snapshot.data
                    ? () {
                        widget._locationBloc.stopRecording();
                        _showDialogToSaveRoute(context);
                      }
                    : () => widget._locationBloc.startRecording(),
                heroTag: null,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            FloatingActionButton.extended(
              label: Text(
                'View routes',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreenAccent),
              ),
              icon: Icon(Icons.album_rounded),
              onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => DraggableScrollableSheet(
                      expand: false,
                      builder: (_, controller) =>
                          NotificationListener<CachedRouteChosenNotification>(
                            onNotification: (notification) {
                              widget._locationBloc
                                  .loadCachedRoute(notification.fileName);
                              return true;
                            },
                            child: SingleChildScrollView(
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
                                        padding: const EdgeInsets.all(16),
                                        child: GridView.count(
                                          physics: ScrollPhysics(),
                                          padding: const EdgeInsets.all(0),
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 12,
                                          crossAxisSpacing: 12,
                                          shrinkWrap: true,
                                          children: [
                                            ...widget._locationBloc.routes.value
                                                .map((e) => LastRouteView(
                                                      model: e,
                                                    )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))),
              heroTag: null,
            )
          ],
        ),
      );

  @override
  bool get wantKeepAlive => true;
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
  final RouteFileModel model;

  const LastRouteView({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.lightBlueAccent,
        elevation: 12.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.all(0),
        child: InkWell(
          onTap: () =>
              CachedRouteChosenNotification(model.startedAt).dispatch(context),
          child: Container(
            width: 150,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Route: ' + model.name),
                const SizedBox(
                  height: 4.0,
                ),
                Text(model.startedAt),
                const SizedBox(
                  height: 4.0,
                ),
                Text(model.finishedAt),
                const SizedBox(
                  height: 4.0,
                ),
                Text('Length: ' + model.lengthInKilometers.toString() + ' km'),
                const SizedBox(
                  height: 4.0,
                ),
                Text('Waster power: ' + model.wastedPowerInWh.toString()),
              ],
            ),
          ),
        ),
      );
}

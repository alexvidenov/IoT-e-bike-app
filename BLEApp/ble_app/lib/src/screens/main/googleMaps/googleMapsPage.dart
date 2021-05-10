import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/screens/main/googleMaps/StatisticsDropDown.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'CachedRouteChosenNotification.dart';
import 'Headers.dart';
import 'LastRouteView.dart';

class MapPage extends StatefulWidget {
  final LocationBloc _locationBloc;
  final bool _isOffline;

  MapPage(this._locationBloc, this._isOffline);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  final _saveFileDialogController = TextEditingController();

  final _editFileNameController = TextEditingController();

  void _showDialogToSaveRoute(context, {String currentRecording}) async {
    _saveFileDialogController.text = currentRecording ?? '';
    await showDialog(
        context: context,
        useRootNavigator: false,
        builder: (_) => AlertDialog(
              title: Text('Save file as:'),
              content: TextField(
                controller: _saveFileDialogController,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK",
                      style: TextStyle(fontSize: 25, color: Colors.green)),
                  onPressed: () {
                    widget._locationBloc
                        .renameFile(_saveFileDialogController.value.text);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> _showDialogToEditRoute(context,
      {String currentFileName, String previousTimeStamp}) async {
    _editFileNameController.text = currentFileName ?? '';
    await showDialog(
        context: context,
        useRootNavigator: false,
        builder: (_) => AlertDialog(
              title: Text('Edit track name'),
              content: TextField(
                controller: _editFileNameController,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK",
                      style: TextStyle(fontSize: 25, color: Colors.green)),
                  onPressed: () {
                    widget._locationBloc
                        .renameFile(_editFileNameController.value.text,
                            previousTimeStamp: previousTimeStamp)
                        .then((_) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    widget._locationBloc.loadCachedRoutes();
    widget._locationBloc.isOffline = widget._isOffline;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(children: [
        StreamBuilder<LocationState>(
          stream: widget._locationBloc.stream,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              Marker marker;
              Circle circle;
              if (snapshot.data.locationData != null) {
                marker = widget._locationBloc
                    .generateNewMarker(snapshot.data.locationData);
                circle = widget._locationBloc
                    .generateNewCircle(snapshot.data.locationData);
              }
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: () => {}, // NOTIFICATIONS,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: widget._locationBloc.initialLocation,
                  zoomControlsEnabled: true,
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
        ),
        StreamBuilder<bool>(
          stream: widget._locationBloc.isShowingRoute,
          initialData: false,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return snapshot.data == true
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 60,
                            color: Colors.red,
                          ),
                          color: Colors.red,
                          onPressed: () =>
                              widget._locationBloc.removeVisibleCachedRoute(),
                        ),
                      ),
                    )
                  : Container();
            } else
              return Container();
          },
        ),
        StreamBuilder(
            stream: widget._locationBloc.currentRouteSelected.stream,
            builder: (_, snapshot) => Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                alignment: Alignment.topLeft,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: StatisticsDropDown(snapshot.data),
                    )))),
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
                      _showDialogToSaveRoute(context,
                          currentRecording:
                              'Track ${widget._locationBloc.routes.value.length}');
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
                            Navigator.of(context).pop();
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
                                        child: StatefulBuilder(
                                          builder: (_, innerSetState) =>
                                              ListView.builder(
                                            itemCount: widget._locationBloc
                                                .routes.value.length,
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(2),
                                            physics: const ScrollPhysics(),
                                            itemBuilder:
                                                (innerContext, index) =>
                                                    LastRouteView(
                                              model: widget
                                                  ._locationBloc.routes.value
                                                  .elementAt(index),
                                              onEdit: (name, startedAt) =>
                                                  _showDialogToEditRoute(
                                                          innerContext,
                                                          currentFileName: name,
                                                          previousTimeStamp:
                                                              startedAt)
                                                      .then((_) =>
                                                          innerSetState(
                                                              () => {})),
                                              onDelete: (startedAt) {
                                                widget._locationBloc
                                                    .deleteFile(startedAt)
                                                    .then((_) => innerSetState(
                                                        () => {}));
                                              },
                                            ),
                                          ),
                                        )),
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
  }

  @override
  bool get wantKeepAlive => true;
}

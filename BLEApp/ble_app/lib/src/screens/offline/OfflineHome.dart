import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/main/googleMapsPage.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/widgets/drawer/navigationDrawer.dart';
import 'package:flutter/material.dart';

class OfflineHome extends RouteAwareWidget<LocationBloc> {
  const OfflineHome(LocationBloc locationBloc) : super(bloc: locationBloc);

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('Cached routes'),
          actions: [
            RaisedButton(child: Text('Go online'), onPressed: () {})
            // TODO: go online
          ],
        ),
        drawer: NavigationDrawer($(), $(), $<Auth>().signOut, isOffline: true),
        body: MapPage(super.bloc, true),
      );
}

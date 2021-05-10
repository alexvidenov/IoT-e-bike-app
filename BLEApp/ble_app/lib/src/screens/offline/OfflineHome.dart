import 'package:ble_app/src/blocs/NavDrawerBloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/main/googleMaps/googleMapsPage.dart';
import 'package:ble_app/src/screens/base/BlocLifecycleAware.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/widgets/drawer/navigationDrawer.dart';
import 'package:flutter/material.dart';

class OfflineHome extends BlocLifecycleAwareWidget<LocationBloc> {
  final NavDrawerBloc _navDrawerBloc;

  const OfflineHome(LocationBloc locationBloc, this._navDrawerBloc)
      : super(bloc: locationBloc);

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
        drawer: NavigationDrawer($(), $(), $<Auth>().signOut,
            _navDrawerBloc.authorizedToAccessParams,
            isOffline: true, isAnonymous: _navDrawerBloc.isAnonymous),
        body: MapPage(super.bloc, true),
      );
}

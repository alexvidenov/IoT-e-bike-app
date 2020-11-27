import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/navigationService.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets.dart';
import 'package:flutter/material.dart';

class DeviceScreen extends RouteAwareWidget {
  final _navigationBloc;

  DeviceScreen(ShortStatusBloc shortStatusBloc)
      : this._navigationBloc = locator<NavigationBloc>(),
        super(bloc: shortStatusBloc);

  @override
  Widget buildWidget(BuildContext context) => InkWell(
        onTap: () => _navigationBloc.navigateTo('/full'),
        child: Container(
          child: ProgressRows(shortStatusBloc: super.bloc),
        ),
      );

  @override
  void onResume() {
    super.onResume();
    _navigationBloc.addEvent(CurrentPage.Short);
  }
}

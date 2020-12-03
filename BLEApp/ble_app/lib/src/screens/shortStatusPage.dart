import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';


class DeviceScreen extends RouteAwareWidget {
  final _navigationBloc;

  DeviceScreen(ShortStatusBloc shortStatusBloc)
      : this._navigationBloc = $<NavigationBloc>(),
        super(bloc: shortStatusBloc);

  @override
  Widget buildWidget(BuildContext context) => InkWell(
        onTap: () => _navigationBloc.navigateTo('/full'),
        child: Container(
          child: ShortStatusUI(shortStatusBloc: super.bloc),
        ),
      );

  @override
  void onResume() {
    super.onResume();
    _navigationBloc.addEvent(CurrentPage.Short);
  }
}

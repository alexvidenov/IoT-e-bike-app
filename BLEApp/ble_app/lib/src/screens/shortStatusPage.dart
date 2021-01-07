import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';

class DeviceScreen extends RouteAwareWidget<ShortStatusBloc>
    with NavigationAware {
  DeviceScreen(ShortStatusBloc shortStatusBloc) : super(bloc: shortStatusBloc);

  @override
  Widget buildWidget(BuildContext context) => InkWell(
        onTap: () => navigationBloc.navigateTo('/full'),
        child: Container(
          child: ShortStatusUI(super.bloc, $()),
        ),
      );

  @override
  void onResume() {
    super.onResume();
    navigationBloc.addEvent(CurrentPage.Short);
  }
}

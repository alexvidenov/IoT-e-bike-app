import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/navigationService.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets.dart';
import 'package:flutter/material.dart';

class DeviceScreen extends RouteAwareWidget {
  const DeviceScreen(ShortStatusBloc shortStatusBloc)
      : super(bloc: shortStatusBloc);

  @override
  Widget buildWidget(BuildContext context) {
    return InkWell(
      onTap: () => locator<NavigationService>().innerNavigateTo('/full'),
      child: Container(
        child: ProgressRows(shortStatusBloc: super.bloc),
      ),
    );
  }

  @override
  void onResume() {
    super.onResume();
    locator<NavigationBloc>().setCurrentPage(CurrentPage.Short);
  }
}

import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets/FullStatusUI/VoltagesBarChart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FullStatusPage extends RouteAwareWidget {
  final NavigationBloc _navigationBloc;

  FullStatusPage(FullStatusBloc fullStatusBloc)
      : this._navigationBloc = locator<NavigationBloc>(),
        super(bloc: fullStatusBloc);

  @override
  Widget buildWidget(BuildContext context) => InkWell(
      onTap: () => _navigationBloc.navigateTo('/map'),
      child: VoltagesBarChart(fullStatusStream: super.bloc.stream));

  @override
  void onResume() {
    super.onResume();
    _navigationBloc.addEvent(CurrentPage.Full);
  }
}

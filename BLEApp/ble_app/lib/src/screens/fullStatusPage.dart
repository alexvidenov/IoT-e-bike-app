import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets/FullStatusUI/VoltagesBarChart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FullStatusPage extends RouteAwareWidget<FullStatusBloc> with NavigationAware {
  FullStatusPage(FullStatusBloc fullStatusBloc)
      : super(bloc: fullStatusBloc);

  @override
  Widget buildWidget(BuildContext context) => InkWell(
      onTap: () => navigationBloc.navigateTo('/map'),
      child: VoltagesBarChart(fullStatusStream: super.bloc.stream));

  @override
  onResume() {
    super.onResume();
    navigationBloc.addEvent(CurrentPage.Full);
  }
}

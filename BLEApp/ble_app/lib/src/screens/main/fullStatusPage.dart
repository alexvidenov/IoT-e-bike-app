import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets/FullStatusUI/VoltagesBarChart.dart';
import 'package:flutter/material.dart';

class FullStatusPage extends RouteAwareWidget<FullStatusBloc> with Navigation {
  const FullStatusPage(FullStatusBloc fullStatusBloc)
      : super(bloc: fullStatusBloc);

  @override
  Widget buildWidget(BuildContext context) => InkWell(
      onTap: () => navigationBloc.to('/map'),
      child: VoltagesBarChart(super.bloc));

  @override
  onResume() {
    super.onResume();
    navigationBloc.addEvent(CurrentPage.Controller);
  }
}

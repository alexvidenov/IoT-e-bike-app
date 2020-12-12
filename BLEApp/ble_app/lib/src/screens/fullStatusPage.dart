import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/widgets/FullStatusUI/VoltagesBarChart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FullStatusPage extends RouteAwareWidget<FullStatusBloc> {
  final NavigationBloc _navigationBloc;

  const FullStatusPage(FullStatusBloc fullStatusBloc, this._navigationBloc)
      : super(bloc: fullStatusBloc);

  @override
  Widget buildWidget(BuildContext context) => InkWell(
      onTap: () => _navigationBloc.navigateTo('/map'),
      child: VoltagesBarChart(fullStatusStream: super.bloc.stream));

  @override
  onResume() {
    super.onResume();
    _navigationBloc.addEvent(CurrentPage.Full);
  }
}

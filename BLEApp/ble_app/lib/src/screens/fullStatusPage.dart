import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/fullStatusBarGraphModel.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets.dart';

// ignore: must_be_immutable
class FullStatusPage extends RouteAwareWidget {
  final NavigationBloc _navigationBloc;

  FullStatusPage(FullStatusBloc fullStatusBloc)
      : this._navigationBloc = locator<NavigationBloc>(),
        super(bloc: fullStatusBloc);

  List<FullStatusDataModel> _chartData;

  SfCartesianChart getBarChart() => SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(
          interval: 1.0,
          minimum: 0,
          maximum: 21,
          labelStyle: TextStyle(fontSize: 20),
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
            majorGridLines: MajorGridLines(width: 0),
            isVisible: false,
            title: AxisTitle(text: ''),
            minimum: 0,
            maximum: 60,
            // inject the max voltage here
            majorTickLines: MajorTickLines(size: 0)),
        series: getBarSeries(),
      );

  List<BarSeries<FullStatusDataModel, int>> getBarSeries() {
    return <BarSeries<FullStatusDataModel, int>>[
      BarSeries<FullStatusDataModel, int>(
        animationDuration: 0.5,
        dataSource: _chartData,
        borderRadius: BorderRadius.circular(3),
        trackColor: Colors.white12,
        isTrackVisible: true,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(color: Colors.white, fontSize: 20)),
        dataLabelMapper: (FullStatusDataModel status, _) =>
            status.y.toString() + "V",
        enableTooltip: true,
        xValueMapper: (FullStatusDataModel status, _) => status.x,
        yValueMapper: (FullStatusDataModel status, _) => status.y,
        pointColorMapper: (FullStatusDataModel status, _) => status.color,
      ),
    ];
  }

  @override
  Widget buildWidget(BuildContext context) {
    return InkWell(
      onTap: () => _navigationBloc.navigateTo('/map'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ProgressText(title: 'Umin.', content: '10V'),
              ProgressText(
                title: 'Ubal.',
                content: '56V', // these values will be get from SharedPrefs
              ),
              ProgressText(
                title: 'Umax.',
                content: '60V',
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ProgressText(title: 'Charge', content: '5A'),
                ProgressText(
                  title: 'Discharge',
                  content: '10A',
                ),
                ProgressText(
                  title: 'Total voltage',
                  content: '60V',
                )
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<List<FullStatusDataModel>>(
                  stream: super.bloc.stream,
                  builder: (_, snapshot) {
                    _chartData = snapshot.data;
                    return getBarChart();
                  })),
        ],
      ),
    );
  }

  @override
  void onResume() {
    super.onResume();
    _navigationBloc.addEvent(CurrentPage.Full);
  }
}

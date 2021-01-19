import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterHolder.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/_BottomProgressText.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class VoltagesBarChart extends StatelessWidget {
  final FullStatusBloc _fullStatusBloc;

  VoltagesBarChart(this._fullStatusBloc);

  List<FullStatusDataModel> _chartData;

  SfCartesianChart getBarChart() => SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(
          interval: 1.0,
          minimum: 0,
          maximum: 15,
          // NUM of cells here
          labelStyle: TextStyle(fontSize: 20),
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
            majorGridLines: MajorGridLines(width: 0),
            isVisible: false,
            title: AxisTitle(text: ''),
            minimum: _fullStatusBloc.getParameters().value.minCellVoltage,
            maximum: _fullStatusBloc.getParameters().value.maxCellVoltage,
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
            (status.y / 100).toString() + "V",
        enableTooltip: true,
        xValueMapper: (FullStatusDataModel status, _) => status.x,
        yValueMapper: (FullStatusDataModel status, _) => status.y,
        pointColorMapper: (FullStatusDataModel status, _) => status.color,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ProgressText(title: 'Umin.', content: '10V'),
              ValueListenableBuilder<DeviceParametersModel>(
                valueListenable: _fullStatusBloc.getParameters(),
                builder: (context, value, _) {
                  return ProgressText(
                    title: 'Ubal.',
                    content: (value.balanceCellVoltage / 100).toString() + 'V',
                  );
                },
              ),
              ProgressText(
                title: 'Umax.',
                content: (_fullStatusBloc.getParameters().value.maxCellVoltage / 100)
                        .toString() +
                    'V',
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
                  stream: this._fullStatusBloc.stream,
                  builder: (_, snapshot) {
                    _chartData = snapshot.data;
                    return getBarChart();
                  })),
        ],
      );
}

import 'package:ble_app/src/blocs/DeviceStatisticsBloc.dart';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DeviceStatisticsScreen extends StatefulWidget {
  final DeviceStatisticsBloc _deviceStatisticsBloc;

  const DeviceStatisticsScreen(this._deviceStatisticsBloc);

  @override
  _DeviceStatisticsScreenState createState() => _DeviceStatisticsScreenState();
}

class _DeviceStatisticsScreenState extends State<DeviceStatisticsScreen> {
  List<LogModel> _chartData;

  @override
  Widget build(BuildContext context) => FutureBuilder<List<LogModel>>(
      future: widget._deviceStatisticsBloc.fetchData(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          _chartData = snapshot.data;
          return _getDefaultLineChart();
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      });

  SfCartesianChart _getDefaultLineChart() => SfCartesianChart(
        backgroundColor: Colors.white,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            intervalType: DateTimeIntervalType.years,
            majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            rangePadding: ChartRangePadding.none,
            minimum: 0,
            maximum: 60,
            interval: 10,
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(color: Colors.transparent)),
        series: _getDefaultLineSeries(),
        trackballBehavior: TrackballBehavior(
            enable: true,
            lineColor: Color.fromRGBO(255, 255, 255, 0.03),
            lineWidth: 15,
            activationMode: ActivationMode.singleTap,
            markerSettings: TrackballMarkerSettings(
                borderWidth: 4,
                height: 10,
                width: 10,
                markerVisibility: TrackballVisibilityMode.visible)),
      );

  List<LineSeries<LogModel, DateTime>> _getDefaultLineSeries() =>
      <LineSeries<LogModel, DateTime>>[
        LineSeries<LogModel, DateTime>(
          dataSource: _chartData,
          xValueMapper: (LogModel model, _) => DateTime.parse(model.timeStamp),
          yValueMapper: (LogModel model, _) => model.voltage,
        ),
      ];
}

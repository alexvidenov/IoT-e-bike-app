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
  void initState() {
    super.initState();
    widget._deviceStatisticsBloc.fetchFileNames();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('DeviceStatistics'),
        ),
        body: Stack(children: [
          StreamBuilder<List<LogModel>>(
            stream: widget._deviceStatisticsBloc.stream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                _chartData = snapshot.data;
                return _getDefaultLineChart();
              } else
                return Center(
                  child: Text('Select file'),
                );
            },
          ),
          DraggableScrollableSheet(
            minChildSize: 0.15,
            maxChildSize: 0.8,
            builder: (_, controller) => Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        height: 8.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'DeviceStatistics',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Text('Select file',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
                StreamBuilder<List<String>>(
                    stream: widget._deviceStatisticsBloc.nameFetchRx.stream,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return Expanded(
                            child: ListView.builder(
                          controller: controller,
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) => ListTile(
                            tileColor: Colors.black12,
                            title: Text(
                              snapshot.data.elementAt(index),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onTap: () =>
                                widget._deviceStatisticsBloc.fetchOne(index),
                          ),
                        ));
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    })
              ],
            ),
          ),
        ]),
      );

  SfCartesianChart _getDefaultLineChart() => SfCartesianChart(
        backgroundColor: Colors.black,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.minutes,
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            rangePadding: ChartRangePadding.none,
            minimum: 0,
            maximum: 60,
            interval: 10,
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0)),
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

  List<SplineSeries<LogModel, DateTime>> _getDefaultLineSeries() =>
      <SplineSeries<LogModel, DateTime>>[
        SplineSeries<LogModel, DateTime>(
          dataSource: _chartData,
          xValueMapper: (LogModel model, _) => DateTime.parse(model.timeStamp),
          yValueMapper: (LogModel model, _) => model.voltage,
        ),
      ];
}




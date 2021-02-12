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
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupSheet());
  }

  Future<void> _setupSheet() async => await _showFileBottomSheet();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('DeviceStatistics'),
        ),
        body: StreamBuilder<List<LogModel>>(
          stream: widget._deviceStatisticsBloc.stream,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              _chartData = snapshot.data;
              return _getDefaultLineChart();
            } else
              return Center(
                child: Text(
                  'Select file',
                  style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 1.5,
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold),
                ),
              );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.build),
          onPressed: () => _showFileBottomSheet(),
        ),
      );

  Future<void> _showFileBottomSheet() async => await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
            expand: false,
            builder: (_, controller) {
              return SingleChildScrollView(
                  controller: controller,
                  child: Card(
                    elevation: 12.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    margin: const EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            height: 5,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Select a file",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black45)),
                              SizedBox(width: 8),
                              Container(
                                height: 24,
                                width: 24,
                                child: Icon(Icons.arrow_downward_outlined,
                                    size: 12, color: Colors.black54),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          StreamBuilder<List<String>>(
                            stream:
                                widget._deviceStatisticsBloc.nameFetchRx.stream,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Column(
                                    children: [
                                      ...snapshot.data.map((s) => Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ListTile(
                                                tileColor:
                                                    Colors.lightBlueAccent,
                                                title: Text(
                                                  s,
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.black),
                                                ),
                                                trailing: const Icon(
                                                    Icons.edit_sharp),
                                                onTap: () => widget
                                                    ._deviceStatisticsBloc
                                                    .fetchOne(snapshot.data
                                                        .indexOf(s))
                                                    .then((_) =>
                                                        Navigator.of(context)
                                                            .pop()),
                                              ),
                                              const Divider(
                                                height: 5.0,
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                );
                              } else
                                return Container();
                            },
                          )
                        ],
                      ),
                    ),
                  ));
            });
      });

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

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
          actions: [
            OutlineButton.icon(
              icon: Icon(Icons.arrow_drop_down_circle_outlined),
              label: Text('Select file',
                  style: TextStyle(
                      color: Colors.black, fontSize: 20, letterSpacing: 1.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              onPressed: () => _showFileBottomSheet(),
            )
          ],
        ),
        body: Column(
          children: [
            Wrap(
              children: [
                OutlineButton(
                  child: Text(
                    'Current',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => widget._deviceStatisticsBloc
                      .changeCurrentStatisticsType(StatisticsType.Current),
                ),
                OutlineButton(
                    child: Text(
                      'Voltage',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => widget._deviceStatisticsBloc
                        .changeCurrentStatisticsType(StatisticsType.Voltage)),
                OutlineButton(
                    child: Text(
                      'Temperature',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => widget._deviceStatisticsBloc
                        .changeCurrentStatisticsType(
                            StatisticsType.Temperature)),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: StreamBuilder<DeviceStatisticsState>(
                stream: widget._deviceStatisticsBloc.stream,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    _chartData = snapshot.data.logs;
                    double max;
                    double interval;
                    switch (snapshot.data.type) {
                      case StatisticsType.Current:
                        max = widget._deviceStatisticsBloc.currentParams
                            .maxCutoffDischargeCurrent; // FIXME: think whether to save the  parametrs AT TIME OF USAGE
                        interval = 1.5;
                        break;
                      case StatisticsType.Voltage:
                        max = 60;
                        interval = 10;
                        break;
                      case StatisticsType.Temperature:
                        max = widget._deviceStatisticsBloc.currentParams
                            .maxCutoffTemperature
                            .toDouble();
                        interval = 5;
                    }
                    return _getDefaultLineChart(
                        max: max, interval: interval, type: snapshot.data.type);
                  } else
                    return Center(
                      child: Text(
                        'No file selected',
                        style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 1.5,
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                },
              ),
            )
          ],
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

  SfCartesianChart _getDefaultLineChart(
          {double max, double min = 0, double interval, StatisticsType type}) =>
      SfCartesianChart(
        backgroundColor: Colors.black,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.minutes,
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            rangePadding: ChartRangePadding.none,
            minimum: min,
            maximum: max,
            interval: 10,
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0)),
        series: _getDefaultLineSeries(type: type),
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

  List<SplineSeries<LogModel, DateTime>> _getDefaultLineSeries(
          {StatisticsType type}) =>
      <SplineSeries<LogModel, DateTime>>[
        SplineSeries<LogModel, DateTime>(
            dataSource: _chartData,
            xValueMapper: (LogModel model, _) =>
                DateTime.parse(model.timeStamp),
            yValueMapper: (LogModel model, _) {
              switch (type) {
                case StatisticsType.Current:
                  return model.current;
                case StatisticsType.Voltage:
                  return model.voltage;
                case StatisticsType.Temperature:
                  return model.temp;
                default:
                  return 0.0; // can't get to here
              }
            }),
      ];
}

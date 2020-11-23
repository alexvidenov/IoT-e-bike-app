import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/fullStatusBarGraphModel.dart';
import 'package:ble_app/src/screens/appBarWidget.dart';
import 'package:ble_app/src/screens/googleMapsPage.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets.dart';

class FullStatusPage extends StatefulWidget {
  final FullStatusBloc _fullStatusBloc;

  const FullStatusPage(Key key, this._fullStatusBloc) : super(key: key);

  @override
  _FullStatusPageState createState() => _FullStatusPageState();
}

class _FullStatusPageState extends State<FullStatusPage> with RouteAware {
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
            maximum: 60, // inject the max voltage here
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
            textStyle: TextStyle(fontSize: 20)),
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
  void initState() {
    super.initState();
    widget._fullStatusBloc.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    super.didPush();
    widget._fullStatusBloc.resume();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    widget._fullStatusBloc.pause();
  }

  @override
  void dispose() {
    super.dispose();
    widget._fullStatusBloc.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    widget._fullStatusBloc.resume();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/map'),
      child: Container(
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
                    stream: widget._fullStatusBloc.stream,
                    builder: (_, snapshot) {
                      _chartData = snapshot.data;
                      return getBarChart();
                    })),
          ],
        ),
      ),
    );
  }
}

/*
class FullStatusPage extends StatefulWidget {
  final FullStatusBloc _fullStatusBloc;

  FullStatusPage(this._fullStatusBloc);

  @override
  _FullStatusPageState createState() => _FullStatusPageState();
}

class _FullStatusPageState extends State<FullStatusPage> with RouteAware {
  List<FullStatusDataModel> _chartData;

  @override
  void initState() {
    super.initState();
    widget._fullStatusBloc.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    print('doooooooooooooooooooooood 2');
    super.didPush();
    widget._fullStatusBloc.resume();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    widget._fullStatusBloc.pause();
  }

  _navigateToMap() => Navigator.of(context).pushNamed('/map');

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
            maximum: 60, // inject the max voltage here
            majorTickLines: MajorTickLines(size: 0)),
        series: getBarSeries(),
        onPointTapped: (_) => _navigateToMap(),
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
            textStyle: TextStyle(fontSize: 20)),
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToMap,
      child: Container(
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
                    stream: widget._fullStatusBloc.stream,
                    builder: (_, snapshot) {
                      _chartData = snapshot.data;
                      return GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MapPage(
                                  locator<LocationBloc>(),
                                ),
                              )),
                          child: getBarChart());
                    })),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    widget._fullStatusBloc.dispose();
  }
}
*/

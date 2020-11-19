import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets.dart';

class FullStatusPage extends StatefulWidget {
  @override
  _FullStatusPageState createState() => _FullStatusPageState();
}

class _FullStatusPageState extends State<FullStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ProgressText(title: 'Umin.', content: '10V'),
              ProgressText(
                title: 'Ubal.',
                content: '56V',
              ),
              ProgressText(
                title: 'Umax.',
                content: '60V',
              )
            ],
          ),
        ),
        Expanded(child: getBarChart()),
      ],
    );
  }

  SfCartesianChart getBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'Cell voltages',
          textStyle: TextStyle(
            fontSize: 20,
            fontFamily: 'Europe_Ext',
            fontWeight: FontWeight.bold,
          )),
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
  }

  List<BarSeries<FullStatusDataModel, int>> getBarSeries() {
    final List<FullStatusDataModel> chartData = [
      // this will be dynamic. Update a var chartData through a streambuilder
      FullStatusDataModel(1, 59.7, Colors.red),
      FullStatusDataModel(2, 34.2, Colors.blue),
      FullStatusDataModel(3, 40, Colors.blue),
      FullStatusDataModel(4, 50.5, Colors.red),
      FullStatusDataModel(5, 20.8, Colors.blue),
      FullStatusDataModel(6, 30, Colors.blue),
      FullStatusDataModel(7, 40, Colors.blue),
      FullStatusDataModel(8, 58, Colors.red),
      FullStatusDataModel(9, 20.5, Colors.blue),
      FullStatusDataModel(10, 30, Colors.blue),
      FullStatusDataModel(11, 20, Colors.blue),
      FullStatusDataModel(12, 55, Colors.red),
      FullStatusDataModel(13, 40, Colors.blue),
      FullStatusDataModel(14, 34, Colors.blue),
      FullStatusDataModel(15, 20, Colors.blue),
      FullStatusDataModel(16, 33.3, Colors.blue),
      FullStatusDataModel(17, 40, Colors.blue),
      FullStatusDataModel(18, 30, Colors.blue),
      FullStatusDataModel(19, 0, Colors.blue),
      FullStatusDataModel(20, 0, Colors.blue),
    ];
    return <BarSeries<FullStatusDataModel, int>>[
      BarSeries<FullStatusDataModel, int>(
        dataSource: chartData,
        borderRadius: BorderRadius.circular(3),
        trackColor: const Color.fromRGBO(198, 201, 207, 1),

        /// If we enable this property as true, then we can show the track of series.
        isTrackVisible: true,
        dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(fontSize: 20)),
        dataLabelMapper: (FullStatusDataModel status, _) =>
            status.y.toString() + "V",
        xValueMapper: (FullStatusDataModel status, _) => status.x,
        yValueMapper: (FullStatusDataModel status, _) => status.y,
        pointColorMapper: (FullStatusDataModel status, _) => status.color,
      ),
    ];
  }
}

class FullStatusDataModel {
  final int x;
  final double y;
  final Color color;
  FullStatusDataModel(this.x, this.y, this.color);
}

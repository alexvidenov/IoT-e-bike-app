import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusModel.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/_BottomProgressText.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class VoltagesBarChart extends StatelessWidget {
  final FullStatusBloc _fullStatusBloc;

  VoltagesBarChart(this._fullStatusBloc);

  List<FullStatusDataModel>
      _chartData; // extract that in a separate  widget in order to  make this immutable

  SfCartesianChart getBarChart() => SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(
          interval: 1.0,
          minimum: 0,
          maximum: 17,
          // NUM OF CELLS HERE
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0),
            isVisible: true,
            title: AxisTitle(text: ''),
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            minimum: _fullStatusBloc.getParameters().value.minCellVoltage,
            maximum: _fullStatusBloc.getParameters().value.maxCellVoltage),
        series: getBarSeries(),
      );

  List<ColumnSeries<FullStatusDataModel, int>> getBarSeries() =>
      <ColumnSeries<FullStatusDataModel, int>>[
        ColumnSeries<FullStatusDataModel, int>(
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
          dataLabelMapper: (FullStatusDataModel status, _) => '',
          // (status.y / 100).toString() + "V",
          enableTooltip: true,
          xValueMapper: (FullStatusDataModel status, _) => status.x,
          yValueMapper: (FullStatusDataModel status, _) => status.y / 100,
          pointColorMapper: (FullStatusDataModel status, _) => status.color,
        ),
      ];

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StreamBuilder<StatusState<FullStatus>>(
            stream: _fullStatusBloc.stream,
            builder: (_, state) {
              if (state.connectionState == ConnectionState.active) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ProgressText(
                      title: 'Utot.',
                      content:
                          state.data.model.totalVoltage.toStringAsFixed(2) +
                              'V',
                    ),
                    ProgressText(
                      title: 'Current',
                      content:
                          state.data.model.current.toStringAsFixed(2) + 'A',
                    ),
                    ProgressText(
                      title: 'Temp.',
                      content: state.data.model.temperature.toString() + '°C',
                    ),
                  ],
                );
              } else
                return Container();
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ValueListenableBuilder<DeviceParameters>(
                  // TODO: extract
                  valueListenable: _fullStatusBloc.getParameters(),
                  builder: (context, value, _) => ProgressText(
                    title: 'Chg. time',
                    content: (value.motoHoursChargeCounter).toString() + 'h',
                  ),
                ),
                StreamBuilder<StatusState<FullStatus>>(
                  stream: _fullStatusBloc.stream,
                  builder: (_, model) =>
                      model.connectionState == ConnectionState.active
                          ? ProgressText(
                              title: 'Bat.status',
                              content: model.data.state.string(),
                            )
                          : Container(),
                ),
                ValueListenableBuilder<DeviceParameters>(
                  valueListenable: _fullStatusBloc.getParameters(),
                  builder: (context, value, _) => ProgressText(
                    title: 'Dch. time',
                    content: (value.motoHoursDischargeCounter).toString() + 'h',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                StreamBuilder<double>(
                  stream: _fullStatusBloc.delta1Holder.stream,
                  builder: (_, model) => model.connectionState ==
                          ConnectionState.active
                      ? ProgressText(
                          title: 'ΔV1Cell',
                          content:
                              model.connectionState == ConnectionState.active
                                  ? ((model.data != null
                                          ? (model.data / 100)
                                          : '-'))
                                      .toString()
                                  : '-')
                      : Container(),
                ),
                StreamBuilder<double>(
                  stream: _fullStatusBloc.delta2Holder.stream,
                  builder: (_, model) => ProgressText(
                    title: 'ΔV2 Cell',
                    content: model.connectionState == ConnectionState.active
                        ? ((model.data != null ? (model.data / 100) : '-'))
                            .toString()
                        : '-',
                  ),
                ),
                ProgressText(
                  title: 'Rin',
                  content: '200',
                ),
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<StatusState<FullStatus>>(
                  stream: _fullStatusBloc.stream,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      _chartData = snapshot.data.model.fullStatus;
                      return getBarChart();
                    } else
                      return Container();
                  })),
        ],
      );
}

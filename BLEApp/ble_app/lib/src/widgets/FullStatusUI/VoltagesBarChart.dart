import 'package:ble_app/src/blocs/status/fullStatusBloc.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusModel.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/utils/StreamListener.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';
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
          enableTooltip: true,
          xValueMapper: (FullStatusDataModel status, _) => status.x,
          yValueMapper: (FullStatusDataModel status, _) => (status.y / 100),
          pointColorMapper: (FullStatusDataModel status, _) => status.color,
        ),
      ];

  @override
  Widget build(BuildContext context) => StreamListener<ServiceNotification>(
      stream: _fullStatusBloc.serviceRx.stream,
      onData: (notification) => notification.dispatch(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      content: state.connectionState == ConnectionState.active
                          ? state.data.model != null
                              ? state.data.model.totalVoltage
                                      .toStringAsFixed(2) +
                                  'V'
                              : '-'
                          : '-',
                      compact: true,
                    ),
                    ProgressText(
                      title: 'Current',
                      content: state.connectionState == ConnectionState.active
                          ? state.data.model != null
                              ? state.data.model.current.toStringAsFixed(2) +
                                  'A'
                              : '-'
                          : '-',
                      compact: true,
                    ),
                    ProgressText(
                      title: 'Temp.',
                      content: state.connectionState == ConnectionState.active
                          ? state.data.model != null
                              ? state.data.model.temperature.toString() + 'C'
                              : '-'
                          : '-',
                      compact: true,
                    ),
                  ],
                );
              } else
                return Container();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ValueListenableBuilder<DeviceParameters>(
                  valueListenable: _fullStatusBloc.getParameters(),
                  builder: (context, value, child) {
                    return ProgressText(
                      title: 'Chg. time',
                      content:
                          (value.motoHoursChargeCounter).toStringAsFixed(0) +
                              'h',
                      compact: true,
                    );
                  }),
              ValueListenableBuilder<DeviceParameters>(
                  valueListenable: _fullStatusBloc.getParameters(),
                  builder: (context, value, child) {
                    return ProgressText(
                      title: 'Dch. time',
                      content:
                          (value.motoHoursDischargeCounter).toStringAsFixed(0) +
                              'h',
                      compact: true,
                    );
                  }),
              StreamBuilder<StatusState<FullStatus>>(
                stream: _fullStatusBloc.stream,
                builder: (_, model) =>
                    model.connectionState == ConnectionState.active
                        ? ProgressText(
                            title: 'Bat.status',
                            content: model.data.state.string(),
                            compact: true,
                          )
                        : Container(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              StreamBuilder<double>(
                  stream: _fullStatusBloc.deltaHolder.stream,
                  builder: (_, model) => ProgressText(
                        title: 'ΔV cell',
                        content: model.connectionState == ConnectionState.active
                            ? ((model.data != null ? (model.data / 100) : '-'))
                                .toString()
                            : '-',
                        compact: true,
                      )),
              StreamBuilder<double>(
                stream: _fullStatusBloc.deltaMaxHolder.stream,
                builder: (_, model) => ProgressText(
                  title: 'ΔV cell max',
                  content: model.connectionState == ConnectionState.active
                      ? ((model.data != null ? (model.data / 100) : '-'))
                          .toString()
                      : '-',
                  compact: true,
                ),
              ),
              ProgressText(
                title: 'Rin',
                content: '200',
                compact: true,
              ),
            ],
          ),
          StreamBuilder<StatusState<FullStatus>>(
            stream: _fullStatusBloc.stream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Wrap(
                  spacing: MediaQuery.of(context).size.width * 0.1,
                  runSpacing: 5.0,
                  direction: Axis.horizontal,
                  children: [
                    ...snapshot.data.model.fullStatus.map((f) => Text(
                          '${f.x} -> ${(f.y / 100).toStringAsFixed(2)} V',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ],
                );
              } else
                return Container();
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
              child: StreamBuilder<StatusState<FullStatus>>(
                  stream: _fullStatusBloc.stream,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data.model != null) {
                        _chartData = snapshot.data.model.fullStatus;
                      } else {
                        _chartData = _chartData
                            .map((e) => FullStatusDataModel(
                                x: e.x, y: 0, color: Colors.transparent))
                            .toList();
                      }
                      return getBarChart();
                    } else
                      return Container();
                  })),
        ],
      ));
}

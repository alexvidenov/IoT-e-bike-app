import 'package:ble_app/src/blocs/status/shortStatusBloc.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WattMeter extends StatelessWidget {
  final ShortStatusBloc _shortStatusBloc;

  const WattMeter(this._shortStatusBloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StatusState<ShortStatus>>(
      stream: _shortStatusBloc.stream,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.55,
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              animationDuration: 330,
              axes: <RadialAxis>[
                _CustomAxis(
                    labelOffset: 15,
                    axisLineStyle: AxisLineStyle(
                        thicknessUnit: GaugeSizeUnit.factor,
                        thickness: 0.06,
                        color: Color.fromARGB(100, 107, 97, 97)),
                    radiusFactor: 0.95,
                    minimum: 0,
                    showTicks: false,
                    maximum: _shortStatusBloc.totalPower * 10,
                    pointers: [
                      RangePointer(
                          value: ((snapshot.data.model.current *
                                  snapshot.data.model.totalVoltage) *
                              -10),
                          width: 0.07,
                          sizeUnit: GaugeSizeUnit.factor,
                          animationDuration: 330,
                          color: Colors.deepPurple,
                          animationType: AnimationType.ease,
                          enableAnimation: true)
                    ])
              ],
            ),
          );
        } else
          return Container();
      },
    );
  }
}

class _CustomAxis extends RadialAxis {
  _CustomAxis({
    double radiusFactor = 1,
    List<GaugePointer> pointers,
    GaugeTextStyle axisLabelStyle,
    AxisLineStyle axisLineStyle,
    double minimum,
    double maximum,
    bool showTicks,
    double labelOffset,
  }) : super(
          pointers: pointers ?? <GaugePointer>[],
          minimum: minimum,
          interval: 10,
          maximum: maximum,
          showTicks: showTicks ?? true,
          showLabels: false,
          labelOffset: labelOffset ?? 20,
          axisLabelStyle: axisLabelStyle ??
              GaugeTextStyle(
                  fontSize: 0,
                  fontFamily: 'Segoe UI',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal),
          axisLineStyle: axisLineStyle ??
              AxisLineStyle(
                thickness: 10,
              ),
          radiusFactor: radiusFactor,
        );

  List<CircularAxisLabel> generateVisibleLabels() => [];
}

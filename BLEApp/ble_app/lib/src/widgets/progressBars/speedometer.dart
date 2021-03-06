import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Speedometer extends StatelessWidget {
  final Stream<double> speedSource;

  const Speedometer({@required this.speedSource});

  @override
  Widget build(BuildContext context) => StreamBuilder<double>(
      stream: speedSource,
      initialData: 0.0,
      builder: (_, snapshot) => Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.55,
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              animationDuration: 500,
              axes: <RadialAxis>[
                _CustomAxis(
                    labelOffset: 15,
                    axisLineStyle: AxisLineStyle(
                        thicknessUnit: GaugeSizeUnit.factor,
                        thickness: 0.2,
                        color: Color.fromARGB(100, 107, 97, 97)),
                    radiusFactor: 0.85,
                    minimum: 0,
                    showTicks: false,
                    maximum: 70,
                    axisLabelStyle:
                        GaugeTextStyle(color: Colors.white, fontSize: 12),
                    pointers: <GaugePointer>[
                      NeedlePointer(
                          enableAnimation: true,
                          gradient: const LinearGradient(
                              colors: const <Color>[
                                Color.fromARGB(100, 204, 163, 0),
                                Color.fromARGB(100, 255, 255, 77),
                              ],
                              stops: const <double>[
                                0.25,
                                0.75
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                          animationType: AnimationType.easeOutBack,
                          value: snapshot.data,
                          lengthUnit: GaugeSizeUnit.factor,
                          animationDuration: 500,
                          needleStartWidth: 10,
                          needleEndWidth: 15,
                          needleLength: 0.8,
                          knobStyle: KnobStyle(
                            knobRadius: 0,
                          )),
                      RangePointer(
                          value: snapshot.data,
                          width: 0.15,
                          sizeUnit: GaugeSizeUnit.factor,
                          animationDuration: 1300,
                          animationType: AnimationType.easeOutBack,
                          gradient: const SweepGradient(colors: const <Color>[
                            Colors.lightGreenAccent,
                            Colors.amber,
                          ], stops: const <double>[
                            0.25,
                            0.75
                          ]),
                          enableAnimation: true)
                    ])
              ],
            ),
          ));
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
          maximum: maximum,
          showTicks: showTicks ?? true,
          labelOffset: labelOffset ?? 20,
          axisLabelStyle: axisLabelStyle ??
              GaugeTextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Segoe UI',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal),
          axisLineStyle: axisLineStyle ??
              AxisLineStyle(
                thickness: 10,
              ),
          radiusFactor: radiusFactor,
        );

  List<CircularAxisLabel> generateVisibleLabels() {
    final List<CircularAxisLabel> _visibleLabels = <CircularAxisLabel>[];
    for (num i = 0; i < 9; i++) {
      final double _value = _calculateLabelValue(i);
      final CircularAxisLabel label = CircularAxisLabel(
          GaugeTextStyle(color: Colors.white, fontSize: 15),
          _value.toInt().toString(),
          i,
          false);
      label.value = _value;
      _visibleLabels.add(label);
    }

    return _visibleLabels;
  }

  double valueToFactor(double value) {
    if (value >= 0 && value <= 2) {
      return (value * 0.125) / 2;
    } else if (value > 2 && value <= 5) {
      return (((value - 2) * 0.125) / (5 - 2)) + (1 * 0.125);
    } else if (value > 5 && value <= 10) {
      return (((value - 5) * 0.125) / (10 - 5)) + (2 * 0.125);
    } else if (value > 10 && value <= 20) {
      return (((value - 10) * 0.125) / (20 - 10)) + (3 * 0.125);
    } else if (value > 20 && value <= 30) {
      return (((value - 20) * 0.125) / (30 - 20)) + (4 * 0.125);
    } else if (value > 30 && value <= 50) {
      return (((value - 30) * 0.125) / (50 - 30)) + (5 * 0.125);
    } else if (value > 50 && value <= 100) {
      return (((value - 50) * 0.125) / (100 - 50)) + (6 * 0.125);
    } else if (value > 100 && value <= 150) {
      return (((value - 100) * 0.125) / (150 - 100)) + (7 * 0.125);
    } else {
      return 1;
    }
  }

  /// To return the label value based on interval
  double _calculateLabelValue(num value) {
    if (value == 0) {
      return 0;
    } else if (value == 1) {
      return 2;
    } else if (value == 2) {
      return 5;
    } else if (value == 3) {
      return 10;
    } else if (value == 4) {
      return 20;
    } else if (value == 5) {
      return 30;
    } else if (value == 6) {
      return 50;
    } else if (value == 7) {
      return 100;
    } else {
      return 150;
    }
  }
}

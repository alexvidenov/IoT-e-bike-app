import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets/progressBars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'modules/shortStatusModel.dart';

class ProgressRows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: ProgressRow(
                    title: 'Temp',
                    progressBar: TemperatureProgressBar(),
                  ))
              // more text here
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ProgressText(
                  title: 'Consumed power',
                  content: '50 W/h'), // this will change obviously
              Divider(),
              ProgressText(title: 'Odo', content: '1000 km'),
              Divider(),
              ProgressText(
                title: "Current power",
                content: "56 W",
              ) // this will change obviously
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ProgressRow(
                  title: 'Battery Voltage',
                  progressBar: VoltageProgressBar(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CurrentRow extends StatelessWidget {
  const CurrentRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ShortStatusBloc>(context);
    return StreamBuilder<ShortStatusModel>(
        stream: bloc.shortStatus,
        builder: (_, shortStatus) {
          var currentCharge = shortStatus.data.getCurrentCharge;
          var currentDischarge = shortStatus.data.getCurrentDischarge;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Discharge",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: FAProgressBar(
                        currentValue: currentCharge
                            .toInt(), // fix that afterwards cuz its baaaad
                        size: 50,
                        maxValue: 27,
                        changeColorValue: 20,
                        changeProgressColor: Colors.red,
                        backgroundColor: Colors.white,
                        progressColor: Colors.blue,
                        animatedDuration: const Duration(milliseconds: 700),
                        direction: Axis.horizontal,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Charge",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 50,
                    child: FAProgressBar(
                      currentValue: currentDischarge
                          .toInt(), // fix that as well currentDischarge.toInt()
                      size: 50,
                      maxValue: 25,
                      changeColorValue: 20,
                      changeProgressColor: Colors.red,
                      backgroundColor: Colors.white,
                      progressColor: Colors.blue,
                      animatedDuration: const Duration(milliseconds: 700),
                      direction: Axis.horizontal,
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}

class TemperatureProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ShortStatusBloc>(context);
    return StreamBuilder<ShortStatusModel>(
        stream: bloc.shortStatus,
        builder: (_, shortStatus) {
          if (shortStatus.connectionState == ConnectionState.active) {
            var temperature = shortStatus.data.getTemperature;
            return Container(
              height: 250,
              width: 80,
              child: FAProgressBar(
                currentValue: temperature.toInt(), // temperature.toInt()
                maxValue: 2000,
                animatedDuration: const Duration(milliseconds: 300),
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.up,
                backgroundColor: Colors.white,
                progressColor: Colors.green,
                changeColorValue: 1500,
                changeProgressColor: Colors.red,
                displayText: 'C',
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class VoltageProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ShortStatusBloc>(context);
    return StreamBuilder<ShortStatusModel>(
        stream: bloc.shortStatus,
        builder: (_, shortStatus) {
          var voltage = shortStatus.data.getTotalVoltage;
          return SleekCircularSlider(
              appearance: appearance09,
              min: 0.00,
              max: 48.0,
              initialValue: voltage);
        });
  }
}

class ProgressRow extends StatelessWidget {
  // contains description and visible progress bar
  final String title;
  final Widget progressBar;

  const ProgressRow({this.title, this.progressBar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          progressBar
        ],
      ),
    );
  }
}

class ProgressText extends StatelessWidget {
  final String title, content;

  ProgressText({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          Text(
            content,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}

// Use that for communication tests
class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var shortStatusBloc = Provider.of<ShortStatusBloc>(context, listen: true);
    return Container(
        child: StreamBuilder<ShortStatusModel>(
            stream: shortStatusBloc.shortStatus,
            builder: (_, shortStatus) {
              if (shortStatus.connectionState == ConnectionState.active) {
                var model = shortStatus.data;
                var charge = model.getCurrentCharge;
                var discharge = model.getCurrentDischarge;
                var voltage = model.getTotalVoltage;
                var temperature = model.getTemperature;
                return Column(
                  children: <Widget>[
                    Text('Voltage - $voltage',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Text('Charge - $charge',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Text('Discharge - $discharge',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Text('Temperature - $temperature',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24))
                  ],
                );
              } else {
                return Container();
              }
            }));
  }
}

class RadialNonLinearLabel extends StatefulWidget {
  const RadialNonLinearLabel({Key key}) : super(key: key);

  @override
  _RadialNonLinearLabelState createState() => _RadialNonLinearLabelState();
}

class _RadialNonLinearLabelState extends State<RadialNonLinearLabel> {
  _RadialNonLinearLabelState();

  @override
  Widget build(BuildContext context) {
    return getRadialNonLinearLabel(true);
  }
}

SfRadialGauge getRadialNonLinearLabel(bool isCardView) {
  return SfRadialGauge(
    enableLoadingAnimation: true,
    animationDuration: 2500,
    axes: <RadialAxis>[
      CustomAxis(
          labelOffset: 15,
          axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15),
          radiusFactor: kIsWeb ? 0.8 : 0.9,
          minimum: 0,
          showTicks: false,
          maximum: 150,
          axisLabelStyle: GaugeTextStyle(fontSize: 12),
          pointers: <GaugePointer>[
            NeedlePointer(
                enableAnimation: true,
                gradient: const LinearGradient(colors: <Color>[
                  Color.fromRGBO(203, 126, 223, 0.1),
                  Color(0xFFCB7EDF)
                ], stops: <double>[
                  0.25,
                  0.75
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                animationType: AnimationType.easeOutBack,
                value: 60,
                lengthUnit: GaugeSizeUnit.factor,
                animationDuration: 1300,
                needleStartWidth: isCardView ? 3 : 4,
                needleEndWidth: isCardView ? 6 : 8,
                needleLength: 0.8,
                knobStyle: KnobStyle(
                  knobRadius: 0,
                )),
            RangePointer(
                value: 60,
                width: 0.15,
                sizeUnit: GaugeSizeUnit.factor,
                color: _pointerColor,
                animationDuration: 1300,
                animationType: AnimationType.easeOutBack,
                gradient: kIsWeb
                    ? null
                    : const SweepGradient(
                        colors: <Color>[Color(0xFF9E40DC), Color(0xFFE63B86)],
                        stops: <double>[0.25, 0.75]),
                enableAnimation: true)
          ])
    ],
  );
}

Color _pointerColor = const Color(0xFF494CA2);

class CustomAxis extends RadialAxis {
  CustomAxis({
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
                  color: Colors.black,
                  fontSize: 15.0,
                  fontFamily: 'Segoe UI',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal),
          axisLineStyle: axisLineStyle ??
              AxisLineStyle(
                color: Colors.grey,
                thickness: 10,
              ),
          radiusFactor: radiusFactor,
        );

  @override
  List<CircularAxisLabel> generateVisibleLabels() {
    final List<CircularAxisLabel> _visibleLabels = <CircularAxisLabel>[];
    for (num i = 0; i < 9; i++) {
      final double _value = _calculateLabelValue(i);
      final CircularAxisLabel label = CircularAxisLabel(
          axisLabelStyle, _value.toInt().toString(), i, false);
      label.value = _value;
      _visibleLabels.add(label);
    }

    return _visibleLabels;
  }

  @override
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

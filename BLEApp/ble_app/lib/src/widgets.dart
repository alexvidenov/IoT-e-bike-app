import 'package:flutter/material.dart';
import 'package:ble_app/src/widgets/progressBars.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'dart:ui';

class ProgressRows extends StatelessWidget {
  final double temperature;
  final double voltage;

  const ProgressRows({@required this.temperature, this.voltage});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ProgressRow(
                  title: 'Temperature',
                  progressBar:
                      TemperatureProgressBar(temperatureValue: temperature)),
              // more text here
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ProgressRow(
                title: 'Voltage',
                progressBar: VoltageProgressBar(voltageValue: voltage),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TemperatureProgressBar extends StatelessWidget {
  final double temperatureValue;

  const TemperatureProgressBar({@required this.temperatureValue});

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      appearance: appearance04,
      min: 0.00,
      max: 2000.0,
      initialValue: temperatureValue,
    );
  }
}

class VoltageProgressBar extends StatelessWidget {
  final double voltageValue;

  const VoltageProgressBar({@required this.voltageValue});

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
        appearance: appearance09,
        min: 0.00,
        max: 48.0,
        initialValue: voltageValue);
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

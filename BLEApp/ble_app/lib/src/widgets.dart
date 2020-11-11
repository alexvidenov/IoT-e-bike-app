import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/widgets/progressBars.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'dart:ui';

import 'modules/shortStatusViewModel.dart';

class ProgressRows extends StatelessWidget {
  final int temperature;
  final double voltage;

  const ProgressRows({@required this.temperature, this.voltage});

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
                    progressBar:
                        TemperatureProgressBar(temperatureValue: temperature)),
              )
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
                  progressBar: VoltageProgressBar(voltageValue: voltage),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class TemperatureProgressBar extends StatefulWidget {
  final int temperatureValue;

  const TemperatureProgressBar({@required this.temperatureValue});

  @override
  _TemperatureProgressBarState createState() => _TemperatureProgressBarState();
}

class _TemperatureProgressBarState extends State<TemperatureProgressBar> {
  @override
  Widget build(BuildContext context) {
    //here will go the BlocBuilder
    return Container(
      height: 250,
      width: 80,
      child: FAProgressBar(
        currentValue: widget.temperatureValue,
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
    return Container(child: BlocBuilder<ShortStatusBloc, ShortStatusViewModel>(
        builder: (_, shortStatus) {
      var charge = shortStatus.getCurrentCharge;
      var discharge = shortStatus.getCurrentDischarge;
      var voltage = shortStatus.getTotalVoltage;
      var temperature = shortStatus.getTemperature;
      return Column(
        children: <Widget>[
          Text('Voltage - $voltage',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Text('Charge - $charge',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Text('Discharge - $discharge',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Text('Temperature - $temperature',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
        ],
      );
    }));
  }
}

import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/widgets/progressBars.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'dart:ui';

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
    return BlocBuilder<ShortStatusBloc, ShortStatusModel>(
        builder: (_, shortStatus) {
      var currentCharge = shortStatus.getCurrentCharge;
      var currentDischarge = shortStatus.getCurrentDischarge;

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
                    currentValue: 21, // fix that afterwards cuz its baaaad
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
                  currentValue: 16, // fix that as well currentDischarge.toInt()
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
    return BlocBuilder<ShortStatusBloc, ShortStatusModel>(
        builder: (_, shortStatus) {
      var temperature = shortStatus.getTemperature;
      return Container(
        height: 250,
        width: 80,
        child: FAProgressBar(
          currentValue: 1000, // temperature.toInt()
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
    });
  }
}

class VoltageProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShortStatusBloc, ShortStatusModel>(
        builder: (_, shortStatus) {
      var voltage = shortStatus.getTotalVoltage;
      return SleekCircularSlider(
          appearance: appearance09, min: 0.00, max: 48.0, initialValue: 36.00);
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
    return Container(child: BlocBuilder<ShortStatusBloc, ShortStatusModel>(
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

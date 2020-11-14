import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets/progressBars/speedometer.dart';
import 'package:ble_app/src/widgets/progressBars/temperatureProgressBar.dart';
import 'package:ble_app/src/widgets/progressBars/voltageProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'modules/shortStatusModel.dart';

class ProgressRows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ProgressRow(
                  title: 'Temp',
                  progressBar: TemperatureProgressBar(),
                )
                // more text here
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Column(
                  children: <Widget>[
                    Text(
                      "20",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 25,
                          color: Colors.black),
                    ),
                    Text(
                      "C",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 25,
                          color: Colors.black),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        RadialNonLinearLabel(),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 80,
                            ), // find a way for these to not be hardcoded
                            child: Column(
                              children: <Widget>[
                                Text("60",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 40)),
                                Text("km/h",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 25)),
                              ],
                            ) // will inject the speed BLoc (the gps thinfg) here
                            )
                      ],
                    ),
                    CurrentRow(),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(top: 36),
                child: Column(
                  children: <Widget>[
                    Text(
                      "56.7",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 25,
                          color: Colors.black),
                    ),
                    Text(
                      "V",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 25,
                          color: Colors.black),
                    ),
                  ],
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: ProgressRow(
                      title: 'Bat.',
                      progressBar: VoltageProgressBar(),
                    )),
                Text(
                  "65%",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 30,
                      color: Colors.black),
                )
                // more text here
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ProgressText(title: 'Consumed power', content: '50 W/h'),
            Divider(),
            ProgressText(title: 'Odo', content: '1000 km'),
            Divider(),
            ProgressText(
              title: "Current power",
              content: "56 W",
            ) // this
          ],
        )
      ],
    ));
  }
}

class CurrentRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<ShortStatusBloc>(context);
    return StreamBuilder<ShortStatusModel>(
        stream: bloc.shortStatus,
        builder: (_, shortStatus) {
          if (shortStatus.connectionState == ConnectionState.active) {
            var currentCharge = shortStatus.data.getCurrentCharge;
            var currentDischarge = shortStatus.data.getCurrentDischarge;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 30,
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: FAProgressBar(
                          currentValue: currentCharge
                              .toInt(), // fix that afterwards cuz its baaaad
                          size: 50,
                          maxValue: 27,
                          changeColorValue: 20,
                          changeProgressColor: Colors.red,
                          backgroundColor: Colors.grey,
                          progressColor: Colors.blue,
                          animatedDuration: const Duration(milliseconds: 700),
                          direction: Axis.horizontal,
                        ),
                      ),
                    ),
                    Text(
                      "CH",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 200, // experimental values
                      height: 30,
                      child: FAProgressBar(
                        currentValue: currentDischarge
                            .toInt(), // fix that as well currentDischarge.toInt()
                        size: 50,
                        maxValue: 25,
                        changeColorValue: 20,
                        changeProgressColor: Colors.red,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.blue,
                        animatedDuration: const Duration(milliseconds: 700),
                        direction: Axis.horizontal,
                      ),
                    ),
                    Text(
                      "DH",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ],
                )
              ],
            );
          } else
            return Container();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        progressBar,
        Divider(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ],
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
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 20.0),
          ),
          Text(
            content,
            style: TextStyle(
                color: Colors.black,
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

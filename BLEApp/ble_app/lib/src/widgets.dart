import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets/progressBars/speedometer.dart';
import 'package:ble_app/src/widgets/progressBars/temperatureProgressBar.dart';
import 'package:ble_app/src/widgets/progressBars/voltageProgressBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:location/location.dart';

import 'di/serviceLocator.dart';
import 'modules/shortStatusModel.dart';

class ProgressRows extends StatelessWidget {
  final ShortStatusBloc shortStatusBloc;

  const ProgressRows({@required this.shortStatusBloc});

  @override
  Widget build(BuildContext context) {
    final locationBloc = locator<LocationBloc>();
    locationBloc.startTrackingLocation();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TemperatureProgressBar(bloc: this.shortStatusBloc),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "20", // StreamBuilder
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 28,
                                color: Colors.white),
                          ),
                          Text(
                            "C",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Temp.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: 'Europe_Ext'),
                ),
                Text(
                  "Cell",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: 'Europe_Ext'),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: 100), // find a way to replace that fixed padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Speedometer(locationBloc: locationBloc),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 110,
                            ), // find a way for these to not be hardcoded
                            child: Column(
                              children: <Widget>[
                                StreamBuilder<LocationData>(
                                    stream: locationBloc.stream,
                                    builder: (context, snapshot) {
                                      String _speedInKMH = '0.0';
                                      if (snapshot.data != null) {
                                        _speedInKMH =
                                            (snapshot.data.speed * 3.6)
                                                .toStringAsPrecision(2);
                                      }
                                      String text = snapshot.connectionState ==
                                              ConnectionState.active
                                          ? _speedInKMH
                                          : '0';
                                      return Text(text,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 49));
                                    }),
                                Text('km/h',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 25)),
                              ],
                            ) // will inject the speed BLoc (the gps thinfg) here
                            )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CurrentRow(bloc: this.shortStatusBloc),
                  ],
                )),
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "56.7",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 28,
                                color: Colors.white),
                          ),
                          Text(
                            "V",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    VoltageProgressBar(bloc: this.shortStatusBloc),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Batt",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: 'Europe_Ext'),
                ),
                Text(
                  "65 %",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      fontFamily: 'Europe_Ext'),
                ),
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ProgressText(title: 'Inst Cons', content: '15 Wh/km'),
            Divider(),
            ProgressText(title: 'Trip Dist', content: '100 km'),
            Divider(),
            ProgressText(
              title: "Rem Dist",
              content: "20 km",
            ) // this
          ],
        )
      ],
    );
  }
}

class CurrentRow extends StatelessWidget {
  final ShortStatusBloc bloc;

  const CurrentRow({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ShortStatusModel>(
        stream: bloc.stream,
        initialData: ShortStatusModel(),
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
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 7.0,
                                spreadRadius: 5.0),
                          ]),
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: FAProgressBar(
                          currentValue: currentCharge //currentCharge
                              .toInt(), // fix that afterwards cuz its baaaad
                          size: 50,
                          maxValue: 27,
                          changeColorValue: 20,
                          changeProgressColor: Colors.redAccent,
                          backgroundColor: Colors.black,
                          progressColor: Colors.lightBlueAccent,
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 200, // experimental values
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 5.0,
                                spreadRadius: 5.0),
                          ]),
                      child: FAProgressBar(
                        currentValue: currentDischarge //currentDischarge
                            .toInt(), // fix that as well currentDischarge.toInt()
                        size: 50,
                        maxValue: 25,
                        changeColorValue: 20,
                        changeProgressColor: Colors.redAccent,
                        backgroundColor: Colors.black,
                        progressColor: Colors.lightBlueAccent,
                        animatedDuration: const Duration(milliseconds: 700),
                        direction: Axis.horizontal,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text("1130W",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                fontFamily: 'Europe_Ext')),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "DH",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: 'Europe_Ext'),
                        )
                      ],
                    )
                  ],
                )
              ],
            );
          } else
            return Container();
        });
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
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
                fontFamily: 'Europe_Ext'),
          ),
          Text(
            content,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                fontFamily: 'Europe_Ext'),
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
    var shortStatusBloc = locator<ShortStatusBloc>();
    return Container(
        child: StreamBuilder<ShortStatusModel>(
            stream: shortStatusBloc.stream,
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

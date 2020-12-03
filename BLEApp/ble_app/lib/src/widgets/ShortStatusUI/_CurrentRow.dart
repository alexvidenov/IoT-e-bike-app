import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

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
                      width: MediaQuery.of(context).size.width * 0.2,
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
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: FAProgressBar(
                          currentValue: currentCharge //currentCharge
                              .toInt(),
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
                    const SizedBox(height: 15),
                    Text("Ch",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            letterSpacing: 1.5)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.4, // experimental values
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
                            .toInt(),
                        // fix that as well currentDischarge.toInt()
                        maxValue: 25,
                        changeColorValue: 20,
                        changeProgressColor: Colors.redAccent,
                        backgroundColor: Colors.black,
                        progressColor: Colors.lightBlueAccent,
                        animatedDuration: const Duration(milliseconds: 700),
                        direction: Axis.horizontal,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: <Widget>[
                        Text("1130w",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                                letterSpacing: 1.5,
                                fontFamily: 'Europe_Ext')),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Dh",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              letterSpacing: 1.5,
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

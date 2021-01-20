import 'package:ble_app/src/sealedStates/shortStatusState.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

// delta v-ta
// delta 1 - sredno v pokoi (po malko ot I threshold)
// delta 2 - sredno kogato e po - golqmo ot idmax2 / 2

class CurrentRow extends StatelessWidget {
  final ShortStatusBloc bloc;

  const CurrentRow({@required this.bloc});

  @override
  Widget build(BuildContext context) => StreamBuilder<ShortStatusState>(
      stream: bloc.stream,
      initialData: ShortStatusState(ShortStatusModel.empty()),
      builder: (_, shortStatus) {
        if (shortStatus.connectionState == ConnectionState.active) {
          var currentCharge;
          Color CCColor = Colors.lightBlueAccent;
          var currentDischarge;
          Color DCColor = Colors.lightBlueAccent;
          shortStatus.data.when((model) {
            currentCharge = model.currentCharge;
            currentDischarge = model.currentDischarge;
          }, error: (error, model) {
            switch (error) {
              case ErrorState.Overcharge:
                CCColor = Colors.red;
                break;
              case ErrorState.OverDischarge:
                DCColor = Colors.red;
                break;
              default:
                break;
            }
            currentCharge = model.currentCharge;
            currentDischarge = model.currentDischarge;
          });
          int charge = bloc
              .getParameters()
              .value
              .maxCutoffChargeCurrent
              .toInt();
          int discharge = bloc
              .getParameters()
              .value
              .maxCutoffDischargeCurrent
              .toInt();
          print('DISCHARGE MAX IS $discharge');
          print('CHARGE MAX IS $charge');
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
                        maxValue: bloc
                            .getParameters()
                            .value
                            .maxCutoffChargeCurrent
                            .toInt(),
                        // should be 800
                        backgroundColor: Colors.black,
                        progressColor: CCColor,
                        animatedDuration: const Duration(milliseconds: 700),
                        direction: Axis.horizontal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text("Chg",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
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
                    decoration: const BoxDecoration(
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
                      maxValue: bloc
                          .getParameters()
                          .value
                          .maxCutoffDischargeCurrent
                          .toInt(),
                      backgroundColor: Colors.black,
                      progressColor: DCColor,
                      animatedDuration: const Duration(milliseconds: 700),
                      direction: Axis.horizontal,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      StreamBuilder<ShortStatusState>(
                        stream: bloc.stream,
                        builder: (_, model) {
                          if (model.connectionState == ConnectionState.active) {
                            var color;
                            double current;
                            model.data.when((state) {
                              // TODO: check for charge or discharge here
                              color = Colors.white;
                              current = state.currentCharge;
                            }, error: (error, state) {
                              color = Colors.red;
                              current = state.currentCharge;
                            });
                            return Text((current / 100).toStringAsFixed(2),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0,
                                    letterSpacing: 1.5,
                                    fontFamily: 'Europe_Ext'));
                          } else
                            return Container();
                        },
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text(
                        "Dch",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
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

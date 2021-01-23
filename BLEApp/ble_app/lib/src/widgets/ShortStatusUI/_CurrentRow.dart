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
      // TODO: optimize the builder not to rerender the row and everything
      stream: bloc.stream,
      initialData: ShortStatusState(ShortStatusModel()),
      builder: (_, shortStatus) {
        if (shortStatus.connectionState == ConnectionState.active) {
          var current;
          Color CCColor = Colors.lightBlueAccent;
          Color DCColor = Colors.lightBlueAccent;
          shortStatus.data.when((model) {
            current = model.current;
          }, error: (error, model) {
            switch (error) {
              case ShortStatusErrorState.Overcharge:
                CCColor = Colors.red;
                break;
              case ShortStatusErrorState.OverDischarge:
                DCColor = Colors.red;
                break;
              default:
                break;
            }
            current = model.current;
          });
          int charge =
              bloc.getParameters().value.maxCutoffChargeCurrent.toInt();
          int discharge =
              bloc.getParameters().value.maxCutoffDischargeCurrent.toInt();
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
                    decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.rectangle,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 5.0,
                              spreadRadius: 5.0),
                        ]),
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: FAProgressBar(
                        currentValue: current > 0
                            ? current //currentCharge
                                .toInt()
                            : 0,
                        size: 50,
                        maxValue: bloc
                            .getParameters()
                            .value
                            .maxCutoffChargeCurrent
                            .toInt(),
                        backgroundColor: Colors.black,
                        progressColor: CCColor,
                        animatedDuration: const Duration(milliseconds: 700),
                        direction: Axis.horizontal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("Chg",
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
                      currentValue: current < 0
                          ? ((current as num) * -1) //currentDischarge
                              .toInt()
                          : 0,
                      maxValue: bloc
                          .getParameters()
                          .value
                          .maxCutoffDischargeCurrent
                          .toInt(),
                      backgroundColor: Colors.black,
                      changeColorValue: bloc
                          .getParameters()
                          .value
                          .maxTimeLimitedDischargeCurrent
                          .toInt(),
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
                              current = state
                                  .current; // or discharge. FIXME fix the data model
                            }, error: (error, state) {
                              color = Colors.white;
                              current = state.current;
                            });
                            return Text(
                                (current / 100).toStringAsFixed(2) + 'A',
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
                        width: 20,
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

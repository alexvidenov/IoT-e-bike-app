import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

// delta v-ta
// delta 1 - sredno v pokoi (po malko ot I threshold)
// delta 2 - sredno kogato e po - golqmo ot idmax2 / 2

// O0\r - off
// O1\r - on

class CurrentRow extends StatelessWidget {
  final ShortStatusBloc bloc;

  const CurrentRow({@required this.bloc});

  @override
  Widget build(BuildContext context) => StreamBuilder<StatusState<ShortStatus>>(
      // TODO: optimize the builder not to rerender the row and everything
      stream: bloc.stream,
      initialData: StatusState(BatteryState.Unknown, ShortStatusModel()),
      builder: (_, shortStatus) {
        if (shortStatus.connectionState == ConnectionState.active) {
          // Check if we even have model
          final current = shortStatus.data.model.current;
          Color CCColor = Colors.lightBlueAccent;
          Color DCColor = Colors.lightBlueAccent;
          switch (shortStatus.data.state) {
            case BatteryState.OverCharge:
              CCColor = Colors.red;
              break;
            case BatteryState.OverDischarge:
              DCColor = Colors.red;
              break;
            default:
              break;
          }
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
                        animatedDuration: const Duration(milliseconds: 300),
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
                      changeProgressColor: Colors.redAccent,
                      animatedDuration: const Duration(milliseconds: 300),
                      direction: Axis.horizontal,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Text((current).toStringAsFixed(2) + 'A',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              letterSpacing: 1.5,
                              fontFamily: 'Europe_Ext')),
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

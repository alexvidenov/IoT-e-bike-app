import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/sealedStates/shortStatusState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';

// abstract these please
class VoltageProgressBar extends StatelessWidget {
  final ShortStatusBloc bloc;

  const VoltageProgressBar({@required this.bloc});

  @override
  Widget build(BuildContext context) => StreamBuilder<ShortStatusState>(
      stream: bloc.stream,
      initialData: ShortStatusState(ShortStatusModel.empty()),
      builder: (_, shortStatus) {
        if (shortStatus.connectionState == ConnectionState.active) {
          double voltage;
          Color color = Colors.lightBlueAccent;
          shortStatus.data.when((model) => voltage = model.totalVoltage,
              error: (errorState, model) {
            voltage = model.totalVoltage;
            if (errorState == ErrorState.HighVoltage) {
              color = Colors.redAccent;
            }
          });
          return Container(
            height: 180,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.white, blurRadius: 7.0, spreadRadius: 8.0),
                ]),
            child: FAProgressBar(
              currentValue: voltage ~/ 100,
              maxValue: 60,
              // bloc.getParameters().maxRecoveryVoltage.toInt(),
              animatedDuration: const Duration(milliseconds: 300),
              direction: Axis.vertical,
              verticalDirection: VerticalDirection.up,
              backgroundColor: Colors.black87,
              progressColor: color,
            ),
          );
        } else
          return Container();
      });
}

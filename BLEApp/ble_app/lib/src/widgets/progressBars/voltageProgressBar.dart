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
      initialData: ShortStatusState(ShortStatusModel()),
      builder: (_, shortStatus) {
        if (shortStatus.connectionState == ConnectionState.active) {
          Color color = Colors.lightBlueAccent;
          final state = shortStatus.data;
          final voltage = state.model.totalVoltage;
          if (state is ShortStatusError &&
              state.errorState == ShortStatusErrorState.HighVoltage) {
            color = Colors.redAccent;
          }
          return Container(
            height: 180,
            width: 20,
            decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.rectangle,
                boxShadow: [
                  const BoxShadow(
                      color: Colors.white, blurRadius: 7.0, spreadRadius: 8.0),
                ]),
            child: FAProgressBar(
              currentValue: voltage ~/ 100,
              maxValue: 60,
              // ((bloc.getParameters().maxRecoveryVoltage) ~/ 100),
              // remove this logic from here
              // 60
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

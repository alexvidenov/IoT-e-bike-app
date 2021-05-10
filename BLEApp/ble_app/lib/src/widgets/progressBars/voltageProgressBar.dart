import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';

// abstract these please
class VoltageProgressBar extends StatelessWidget {
  final ShortStatusBloc bloc;

  const VoltageProgressBar({@required this.bloc});

  @override
  Widget build(BuildContext context) => StreamBuilder<StatusState<ShortStatus>>(
      stream: bloc.stream,
      initialData: StatusState(BatteryState.Unknown, ShortStatusModel()),
      builder: (_, shortStatus) {
        if (shortStatus.connectionState == ConnectionState.active &&
            shortStatus.data.model != null) {
          Color color = Colors.lightBlueAccent;
          final state = shortStatus.data.state;
          final voltage = shortStatus.data.model.totalVoltage;
          if (state == BatteryState.EndOfCharge) color = Colors.redAccent;
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
              currentValue: ((voltage - bloc.minVoltage) * 100).toInt(),
              maxValue: ((bloc.totalVoltage - bloc.minVoltage) * 100).toInt(),
              animatedDuration: const Duration(milliseconds: 200),
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

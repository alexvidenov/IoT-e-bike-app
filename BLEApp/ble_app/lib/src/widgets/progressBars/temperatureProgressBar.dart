import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/sealedStates/shortStatusState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';

class TemperatureProgressBar extends StatelessWidget {
  final ShortStatusBloc bloc;

  const TemperatureProgressBar({@required this.bloc});

  @override
  Widget build(BuildContext context) => StreamBuilder<ShortStatusState>(
      stream: bloc.stream,
      initialData: ShortStatusState(ShortStatusModel.empty()),
      builder: (_, shortStatus) {
        if (shortStatus.connectionState == ConnectionState.active) {
          double temperature;
          Color color = Colors.greenAccent;
          shortStatus.data.when((normal) => temperature = normal.temperature,
              error: (errorState, model) {
            switch (errorState) {
              case ErrorState.HighTemp:
                color = Colors.red;
                break;
              case ErrorState.LowTemp:
                color = Colors.lightBlueAccent;
                break;
              default:
                break;
            }
            temperature = model.temperature;
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
              currentValue: temperature.toInt(),
              maxValue: 2000,
              animatedDuration: const Duration(milliseconds: 300),
              direction: Axis.vertical,
              verticalDirection: VerticalDirection.up,
              backgroundColor: Colors.black87,
              progressColor: color,
            ),
          );
        } else {
          return Container();
        }
      });
}

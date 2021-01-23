import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/sealedStates/shortStatusState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';

// < min -> blue
// > max -> red
// otherwise -> green

class TemperatureProgressBar extends StatelessWidget {
  final ShortStatusBloc
      bloc; // TODO: actually pass only the necessary stream here

  const TemperatureProgressBar({@required this.bloc});

  @override
  Widget build(BuildContext context) => StreamBuilder<ShortStatusState>(
      stream: bloc.stream,
      initialData: ShortStatusState(ShortStatusModel()),
      builder: (_, shortStatus) {
        if (shortStatus.connectionState == ConnectionState.active) {
          final temperature = shortStatus.data.model.temperature;
          var color = Colors.greenAccent;
          final state = shortStatus.data;
          if (state is ShortStatusError) {
            print('RECEIVED ERROR STATE IN TEMP. PROG BAR');
            switch (state.errorState) {
              case ShortStatusErrorState.LowTemp:
                color = Colors.lightBlueAccent;
                break;
              case ShortStatusErrorState.HighTemp:
                color = Colors.redAccent;
                break;
              default:
                break;
            }
          }
          return Container(
            height: 180,
            width: 20,
            decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.rectangle,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.white, blurRadius: 7.0, spreadRadius: 8.0),
                ]),
            child: FAProgressBar(
              currentValue: temperature,
              maxValue: 65,
              // should be FIXED
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

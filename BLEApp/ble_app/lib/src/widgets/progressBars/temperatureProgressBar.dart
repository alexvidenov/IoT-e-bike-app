import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';

class TemperatureProgressBar extends StatelessWidget {
  final ShortStatusBloc bloc;

  const TemperatureProgressBar({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ShortStatusModel>(
        stream: bloc.stream,
        initialData: ShortStatusModel.empty(),
        builder: (_, shortStatus) {
          if (shortStatus.connectionState == ConnectionState.active) {
            final temperature = shortStatus.data.temperature;
            return Container(
              height: 180,
              width: 20,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 7.0,
                        spreadRadius: 8.0),
                  ]),
              child: FAProgressBar(
                currentValue: temperature.toInt(), // temperature.toInt()
                maxValue: 2000,
                animatedDuration: const Duration(milliseconds: 300),
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.up,
                backgroundColor: Colors.black87,
                progressColor: Colors.greenAccent,
                changeColorValue: 1500,
                changeProgressColor: Colors.red,
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

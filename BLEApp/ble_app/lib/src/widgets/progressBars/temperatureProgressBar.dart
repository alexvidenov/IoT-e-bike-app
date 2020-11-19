import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:ble_app/src/modules/shortStatusModel.dart';

class TemperatureProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = GetIt.I<ShortStatusBloc>();
    return StreamBuilder<ShortStatusModel>(
        stream: bloc.behaviourSubject$,
        initialData: ShortStatusModel(),
        builder: (_, shortStatus) {
          if (shortStatus.connectionState == ConnectionState.active) {
            var temperature = shortStatus.data.getTemperature;
            return Container(
              height: 180,
              width: 40,
              child: FAProgressBar(
                currentValue: temperature
                    .toInt(), //temperature.toInt(), // temperature.toInt()
                maxValue: 2000,
                animatedDuration: const Duration(milliseconds: 300),
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.up,
                backgroundColor: Colors.grey,
                progressColor: Colors.green,
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

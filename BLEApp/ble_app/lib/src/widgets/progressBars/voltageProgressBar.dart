import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'package:ble_app/src/modules/shortStatusModel.dart';

class VoltageProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = GetIt.I<ShortStatusBloc>();
    return StreamBuilder<ShortStatusModel>(
        stream: bloc.shortStatus,
        builder: (_, shortStatus) {
          if (shortStatus.connectionState == ConnectionState.active) {
            var voltage = shortStatus.data.getTotalVoltage;
            return Container(
              height: 250,
              width: 40,
              child: FAProgressBar(
                currentValue: voltage.toInt(), // temperature.toInt()
                maxValue: 2000,
                animatedDuration: const Duration(milliseconds: 300),
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.up,
                backgroundColor: Colors.blueGrey,
                progressColor: Colors.green,
                changeColorValue: 1500,
                changeProgressColor: Colors.red,
              ),
            );
          } else
            return Container();
        });
  }
}

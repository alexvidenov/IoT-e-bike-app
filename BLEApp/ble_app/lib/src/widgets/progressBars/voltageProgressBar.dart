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
        stream: bloc.stream,
        initialData: ShortStatusModel(),
        builder: (_, shortStatus) {
          if (shortStatus.connectionState == ConnectionState.active) {
            var voltage = shortStatus.data.getTotalVoltage;
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
                currentValue: voltage.toInt(),
                maxValue: 2000,
                animatedDuration: const Duration(milliseconds: 300),
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.up,
                backgroundColor: Colors.black87,
                progressColor: Colors.blue,
                changeColorValue: 1500,
                changeProgressColor: Colors.red,
              ),
            );
          } else
            return Container();
        });
  }
}

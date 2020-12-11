import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/di/serviceLocator.dart';

// Use that for communication tests
class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var shortStatusBloc = $<ShortStatusBloc>();
    return Container(
        child: StreamBuilder<ShortStatusModel>(
            stream: shortStatusBloc.stream,
            builder: (_, shortStatus) {
              if (shortStatus.connectionState == ConnectionState.active) {
                final model = shortStatus.data;
                final charge = model.currentCharge;
                final discharge = model.currentDischarge;
                final voltage = model.totalVoltage;
                final temperature = model.temperature;
                return Column(
                  children: <Widget>[
                    Text('Voltage - $voltage',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Text('Charge - $charge',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Text('Discharge - $discharge',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    Text('Temperature - $temperature',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24))
                  ],
                );
              } else {
                return Container();
              }
            }));
  }
}

import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:flutter/material.dart';

import '_BottomProgressText.dart';
import '_ProgressBars.dart';

class ShortStatusUI extends StatelessWidget {
  final ShortStatusBloc _shortStatusBloc;
  final LocationBloc _locationBloc;

  const ShortStatusUI(this._shortStatusBloc, this._locationBloc);

  @override
  Widget build(BuildContext context) {
    _locationBloc.create();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        StreamBuilder<StatusState<ShortStatus>>(
          stream: _shortStatusBloc.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final state = snapshot.data.state.string();
              return Text(
                'State: $state',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.0,
                    fontFamily: 'Europe_Ext'),
              );
            } else
              return Container();
          },
        ),
        ProgressColumns(
            shortStatusBloc: _shortStatusBloc, locationBloc: _locationBloc),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ProgressText(title: 'Inst Cons', content: '15 Wh/km'),
            Divider(),
            ProgressText(title: 'Trip Dist', content: '100 km'),
            Divider(),
            ProgressText(
              title: "Rem Dist",
              content: "20 km", // listen to this value from some bloc later on
            ) // this
          ],
        )
      ],
    );
  }
}

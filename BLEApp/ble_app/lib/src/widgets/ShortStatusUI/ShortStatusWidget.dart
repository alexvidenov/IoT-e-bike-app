import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
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

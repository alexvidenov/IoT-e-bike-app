import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:flutter/material.dart';

import '_BottomProgressText.dart';
import '_ProgressBars.dart';

class ShortStatusUI extends StatelessWidget {
  final ShortStatusBloc shortStatusBloc;

  const ShortStatusUI({@required this.shortStatusBloc});

  @override
  Widget build(BuildContext context) {
    final locationBloc = locator<LocationBloc>();
    locationBloc.startTrackingLocation();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ProgressColumns(shortStatusBloc: shortStatusBloc, locationBloc: locationBloc),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ProgressText(title: 'Inst Cons', content: '15 Wh/km'),
            Divider(),
            ProgressText(title: 'Trip Dist', content: '100 km'),
            Divider(),
            ProgressText(
              title: "Rem Dist",
              content: "20 km",
            ) // this
          ],
        )
      ],
    );
  }
}
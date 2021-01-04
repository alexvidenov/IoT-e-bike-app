import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets/progressBars/speedometer.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/_CurrentRow.dart';
import 'package:location/location.dart';

class SpeedometerWithCurrent extends StatelessWidget {
  const SpeedometerWithCurrent({
    Key key,
    @required this.locationBloc,
    @required this.shortStatusBloc,
  }) : super(key: key);

  final LocationBloc locationBloc;
  final ShortStatusBloc shortStatusBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Speedometer(locationBloc: locationBloc),
            Padding(
                padding: EdgeInsets.only(
                  top: 110,
                ), // find a way for these to not be hardcoded
                child: Column(
                  children: <Widget>[
                    StreamBuilder<LocationData>(
                        stream: locationBloc.stream,
                        builder: (context, snapshot) {
                          String _speedInKMH = '0.0';
                          if (snapshot.data != null) {
                            _speedInKMH = (snapshot.data.speed * 3.6)
                                .toStringAsPrecision(1);
                          }
                          String text =
                              snapshot.connectionState == ConnectionState.active
                                  ? _speedInKMH
                                  : '0';
                          return Text(text,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 56));
                        }),
                    Text('km/h',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 25)),
                  ],
                ))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        CurrentRow(bloc: this.shortStatusBloc),
      ],
    );
  }
}

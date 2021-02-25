import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets/progressBars/speedometer.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/_CurrentRow.dart';
import 'package:location/location.dart';

class SpeedometerWithCurrent extends StatelessWidget {
  final LocationBloc locationBloc;
  final ShortStatusBloc shortStatusBloc;

  const SpeedometerWithCurrent({
    Key key,
    @required this.locationBloc,
    @required this.shortStatusBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SpeedometerWidget(locationBloc: locationBloc),
            Padding(
                padding: EdgeInsets.only(
                  top: 110,
                ), // find a way for these to not be hardcoded
                child: Column(
                  children: <Widget>[
                    StreamBuilder<double>(
                        stream: locationBloc.speedRx.stream,
                        builder: (context, snapshot) {
                          String _speedInKMH = '0.0';
                          if (snapshot.data != null) {
                            _speedInKMH =
                                (snapshot.data * 3.6).toStringAsFixed(1);
                          }
                          return Text(
                              snapshot.connectionState == ConnectionState.active
                                  ? _speedInKMH
                                  : '0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 56));
                        }),
                    const Text('km/h',
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

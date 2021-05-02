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
                          final speed = snapshot.data;
                          var speedInKMH = '0.0';
                          if (speed != null && speed > 2.0) {
                            speedInKMH = (speed * 3.6).toStringAsFixed(1);
                          }
                          return Row(
                            children: [
                              Text('${speedInKMH[0]}' + '${speedInKMH[1]}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 56)),
                              Text('${speedInKMH[2]}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30))
                            ],
                          );
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

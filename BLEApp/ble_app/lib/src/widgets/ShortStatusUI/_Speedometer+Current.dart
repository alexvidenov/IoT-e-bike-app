import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:ble_app/src/widgets/progressBars/WattMeter.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/location/locationBloc.dart';
import 'package:ble_app/src/blocs/status/shortStatusBloc.dart';
import 'package:ble_app/src/widgets/progressBars/speedometer.dart';

import '../progressBars/speedometer.dart';
import '_CurrentRow.dart';

class SpeedometerWithCurrent extends StatelessWidget {
  final LocationBloc locationBloc;
  final ShortStatusBloc shortStatusBloc;

  const SpeedometerWithCurrent({
    Key key,
    @required this.locationBloc,
    @required this.shortStatusBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              WattMeter(shortStatusBloc),
              Speedometer(speedSource: locationBloc.speedRx.stream),
              Padding(
                padding: EdgeInsets.only(top: 220),
                child: StreamBuilder<StatusState<ShortStatus>>(
                  stream: shortStatusBloc.stream,
                  initialData:
                      StatusState(BatteryState.Unknown, ShortStatusModel()),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final power = ((snapshot.data.model.current *
                              snapshot.data.model.totalVoltage) *
                          -1);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${power.truncate()}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('W',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25))
                        ],
                      );
                    } else
                      return Container();
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    top: 40,
                  ),
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<double>(
                          stream: locationBloc.speedRx.stream,
                          initialData: 0.0,
                          builder: (context, snapshot) {
                            final speed = snapshot.data.toStringAsFixed(2);
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${speed[0]}' + '${speed[1]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 56)),
                                Text('${speed[2]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30))
                              ],
                            );
                          }),
                      const Text('km/h',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 25)),
                    ],
                  ))
            ],
          ),
          const SizedBox(height: 30,),
        ],
      );
}

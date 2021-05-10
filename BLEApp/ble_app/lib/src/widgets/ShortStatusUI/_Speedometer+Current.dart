import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets/progressBars/speedometer.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/_CurrentRow.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import '../progressBars/speedometer.dart';

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
              Speedometer(speedSource: locationBloc.speedRx.stream),
              Padding(
                  padding: EdgeInsets.only(
                    top: 60,
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
                                        fontWeight: FontWeight.w500,
                                        fontSize: 56)),
                                Text('${speed[2]}',
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
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 20,
              decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.rectangle,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white,
                        blurRadius: 5.0,
                        spreadRadius: 5.0),
                  ]),
              child: StreamBuilder<StatusState<ShortStatus>>(
                stream: shortStatusBloc.stream,
                initialData:
                    StatusState(BatteryState.Unknown, ShortStatusModel()),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return FAProgressBar(
                      currentValue: ((snapshot.data.model.current *
                                  snapshot.data.model.totalVoltage) *
                              -10)
                          .toInt(),
                      size: 50,
                      maxValue: (shortStatusBloc.totalPower * 10).toInt(),
                      backgroundColor: Colors.black,
                      progressColor: Colors.purple,
                      animatedDuration: const Duration(milliseconds: 300),
                      direction: Axis.horizontal,
                    );
                  } else
                    return Container();
                },
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: <Widget>[
                StreamBuilder<StatusState<ShortStatus>>(
                  stream: shortStatusBloc.stream,
                  initialData:
                      StatusState(BatteryState.Unknown, ShortStatusModel()),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var power = (snapshot.data.model.current *
                              snapshot.data.model.totalVoltage) *
                          -1;
                      if (power.isNegative) {
                        power = 0.0;
                      }
                      return Text('${power.toStringAsFixed(1)} W',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              letterSpacing: 1.5,
                              fontFamily: 'Europe_Ext'));
                    } else
                      return Container();
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  "Power",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      letterSpacing: 1.5,
                      fontFamily: 'Europe_Ext'),
                )
              ],
            )
          ]),
          const SizedBox(
            height: 15,
          ),
          CurrentRow(bloc: this.shortStatusBloc),
        ],
      );
}

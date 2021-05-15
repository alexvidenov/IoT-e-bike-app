import 'package:ble_app/src/blocs/location/locationBloc.dart';
import 'package:ble_app/src/blocs/status/shortStatusBloc.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:ble_app/src/utils/StreamListener.dart';
import 'package:flutter/material.dart';

import '_BottomProgressText.dart';
import '_ProgressBars.dart';

class ServiceNotification extends Notification {
  final BatteryState state;
  final bool isStateGone;

  const ServiceNotification({this.state, @required this.isStateGone});
}

class ShortStatusUI extends StatelessWidget {
  final ShortStatusBloc _shortStatusBloc;
  final LocationBloc _locationBloc;

  const ShortStatusUI(this._shortStatusBloc, this._locationBloc);

  @override
  Widget build(BuildContext context) => CustomScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamListener<ServiceNotification>(
                  stream: _shortStatusBloc.serviceRx.stream,
                  onData: (notification) => notification.dispatch(context),
                  child: StreamBuilder<StatusState<ShortStatus>>(
                    stream: _shortStatusBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        final state = snapshot.data.state;
                        final stateAsString = snapshot.data.state.string();
                        if (state == BatteryState.Locked) {
                          // FIXME prolly move that icon to the appBar title or some shit, rn it fucks up the UI
                          return Icon(
                            Icons.lock,
                            size: 150,
                            color: Colors.redAccent,
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Batt: $stateAsString',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25.0,
                                  fontFamily: 'Europe_Ext'),
                            ),
                            const SizedBox(width: 30),
                            StreamBuilder<int>(
                              stream: _shortStatusBloc.overCurrentTimer.stream,
                              builder: (_, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.active &&
                                    snapshot.data != -1) {
                                  final String counter =
                                      snapshot.data.toString();
                                  return Text(counter,
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold));
                                } else
                                  return Container();
                              },
                            )
                          ],
                        );
                      } else
                        return Container();
                    },
                  ),
                ),
                ProgressColumns(
                    shortStatusBloc: _shortStatusBloc,
                    locationBloc: _locationBloc),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    StreamBuilder<StatusState<ShortStatus>>(
                        stream: _shortStatusBloc.stream,
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            final watts = snapshot.data.model.totalVoltage *
                                -snapshot.data.model.current;
                            final currentSpeed = _locationBloc.speedRx.value;
                            String text;
                            if (currentSpeed != null &&
                                currentSpeed > 4.0 &&
                                -snapshot.data.model.current >
                                    _shortStatusBloc.currentParams
                                        .motoHoursCounterCurrentThreshold) {
                              text = (watts / currentSpeed).toStringAsFixed(1) +
                                  'Wh/km';
                            } else
                              text = ' - ';
                            return ProgressText(
                                title: 'Inst Cons', content: text);
                          } else
                            return ProgressText(
                                title: 'Inst Cons', content: ' - ');
                        }),
                    const Divider(),
                    StreamBuilder<double>(
                      stream: _locationBloc.kilometres,
                      builder: (_, snapshot) => ProgressText(
                          title: 'Trip Dist',
                          content:
                              snapshot.connectionState == ConnectionState.active
                                  ? ((snapshot.data / 1000).toStringAsFixed(2) +
                                      'km')
                                  : ' - '),
                    ),
                    const Divider(),
                    ProgressText(
                      title: "Rem Dist",
                      content: "20 km",
                    ) // this
                  ],
                )
              ],
            ),
          )
        ],
      );
}

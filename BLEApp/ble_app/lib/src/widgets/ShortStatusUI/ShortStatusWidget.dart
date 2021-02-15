import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
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
  Widget build(BuildContext context) {
    _locationBloc.create();
    return Column(
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
                          final String counter = snapshot.data.toString();
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

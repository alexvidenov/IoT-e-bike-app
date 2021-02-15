import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/sealedStates/statusState.dart';
import 'package:ble_app/src/widgets/progressBars/temperatureProgressBar.dart';
import 'package:ble_app/src/widgets/progressBars/voltageProgressBar.dart';
import 'package:flutter/material.dart';

import '_Speedometer+Current.dart';

class ProgressColumns extends StatelessWidget {
  const ProgressColumns({
    @required this.shortStatusBloc,
    @required this.locationBloc,
  });

  final ShortStatusBloc shortStatusBloc;
  final LocationBloc locationBloc;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TemperatureProgressBar(bloc: this.shortStatusBloc),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<StatusState<ShortStatus>>(
                          stream: shortStatusBloc.stream,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.active &&
                                snapshot.data.model != null) {
                              return Text(
                                  snapshot.data.model.temperature
                                      .toInt()
                                      .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 28,
                                      color: Colors.white));
                            } else
                              return Container();
                          },
                        ),
                        Text(
                          "C",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Temp.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Europe_Ext'),
              ),
              const Text(
                "Cell",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Europe_Ext'),
              ),
            ],
          ),
          SpeedometerWithCurrent(
              locationBloc: locationBloc, shortStatusBloc: shortStatusBloc),
          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<StatusState<ShortStatus>>(
                          stream: shortStatusBloc.stream,
                          initialData: StatusState(
                              BatteryState.Unknown, ShortStatusModel()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.active &&
                                snapshot.data.model != null) {
                              String voltageText = snapshot
                                  .data.model.totalVoltage
                                  .toStringAsFixed(1);
                              return Text(
                                voltageText,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 28,
                                    color: Colors.white),
                              );
                            } else
                              return Container();
                          },
                        ),
                        const Text(
                          "V",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  VoltageProgressBar(bloc: this.shortStatusBloc),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Batt",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Europe_Ext'),
              ),
              Text(
                // TODO: calculate that too
                "65 %",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    fontFamily: 'Europe_Ext'),
              ),
            ],
          )
        ],
      );
}

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/sealedStates/shortStatusState.dart';
import 'package:ble_app/src/widgets/progressBars/temperatureProgressBar.dart';
import 'package:ble_app/src/widgets/progressBars/voltageProgressBar.dart';
import 'package:flutter/material.dart';

import '_Speedometer+Current.dart';

class ProgressColumns extends StatelessWidget {
  const ProgressColumns({
    Key key,
    @required this.shortStatusBloc,
    @required this.locationBloc,
  }) : super(key: key);

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
                        Text(
                          "20", // StreamBuilder
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 28,
                              color: Colors.white),
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
              Text(
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
                        VoltageText(shortStatusBloc),
                        Text(
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
              Text(
                "Batt",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontFamily: 'Europe_Ext'),
              ),
              Text(
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

class VoltageText extends StatelessWidget {
  final ShortStatusBloc _shortStatusBloc;

  const VoltageText(this._shortStatusBloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ShortStatusState>(
      stream: _shortStatusBloc.stream,
      initialData: ShortStatusState(ShortStatusModel.empty()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          String voltageText;
          snapshot.data.when((model) {
            voltageText = (model.totalVoltage / 100).toStringAsFixed(1);
          }, error: (error, model) {
            voltageText = (model.totalVoltage / 100).toStringAsFixed(1);
          });
          return Text(
            voltageText, // StreamBuilder
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 28,
                color: Colors.white),
          );
        } else
          return Container();
      },
    );
  }
}

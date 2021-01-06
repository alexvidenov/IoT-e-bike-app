import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/widgets/testSpeedometer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Speedometer extends StatelessWidget {
  final LocationBloc locationBloc;

  Speedometer({Key key, @required this.locationBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocationData>(
        stream: locationBloc.stream,
        builder: (_, snapshot) {
          double _speed = 0.0;
          if (snapshot.data != null) {
            _speed = snapshot.data.speed * 3.6;
          }
          return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.5,
              child: TestSpeedometer(speed: _speed));
        });
  }
}
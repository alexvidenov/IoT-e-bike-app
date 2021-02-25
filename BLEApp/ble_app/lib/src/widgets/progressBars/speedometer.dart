import 'package:ble_app/src/blocs/locationBloc.dart';
import 'package:ble_app/src/widgets/progressBars/SpeedometerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SpeedometerWidget extends StatelessWidget {
  final LocationBloc locationBloc;

  const SpeedometerWidget({Key key, @required this.locationBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<LocationState>(
      stream: locationBloc.stream,
      builder: (_, snapshot) {
        double _speed = 0.0;
        if (snapshot.data != null) {
          _speed = snapshot.data.locationData.speed * 3.6;
        }
        return Container(
            child: Speedometer(speed: _speed < 2.0 ? 0.0 : _speed));
      });
}

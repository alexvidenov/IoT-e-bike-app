import 'package:ble_app/src/screens/Entrypoints/Entrypoint.dart';
import 'package:ble_app/src/utils/Router.dart' as R;
import 'package:flutter/material.dart';

class DevicesEntrypoint extends EntryPoint {
  DevicesEntrypoint({Key key})
      : super(
            key: key,
            onGenerateRoute:
                R.Router.generateRouteMainNavigatorStartsWithDevices);
}

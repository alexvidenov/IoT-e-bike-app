import 'package:ble_app/src/screens/Entrypoints/Entrypoint.dart';
import 'package:ble_app/src/utils/Router.dart';
import 'package:flutter/material.dart';

class DevicesEntrypoint extends EntryPoint {
  const DevicesEntrypoint({Key key})
      : super(
            key: key,
            onGenerateRoute:
                Router.generateRouteMainNavigatorStartsWithDevices);
}

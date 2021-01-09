import 'package:ble_app/src/screens/Entrypoints/Entrypoint.dart';
import 'package:ble_app/src/utils/Router.dart' as router;
import 'package:flutter/material.dart';

class AuthEntryPoint extends EntryPoint {
  AuthEntryPoint({Key key})
      : super(
            key: key,
            onGenerateRoute: router.Router.generateRouteMainNavigatorStartsWithAuth);
}

import 'package:ble_app/src/screens/Entrypoints/Entrypoint.dart';
import 'package:ble_app/src/utils/Router.dart';
import 'package:flutter/material.dart';

class AuthEntrypoint extends EntryPoint {
  const AuthEntrypoint({Key key})
      : super(
            key: key,
            onGenerateRoute: Router.generateRouteMainNavigatorStartsWithAuth);
}

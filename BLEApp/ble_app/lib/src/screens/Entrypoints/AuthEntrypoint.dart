import 'package:ble_app/src/screens/Entrypoints/Entrypoint.dart';
import 'package:ble_app/src/utils/Router.dart'as R;
import 'package:flutter/material.dart';

class AuthEntrypoint extends EntryPoint {
  AuthEntrypoint({Key key})
      : super(
            key: key,
            onGenerateRoute: R.Router.generateRouteMainNavigatorStartsWithAuth);
}


import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';

// can only be mixed with Stateful widgets
mixin Navigation implements StatefulWidget {
  NavigationBloc get navigationBloc =>
      $<NavigationBloc>(); // prolly extract only the function
}

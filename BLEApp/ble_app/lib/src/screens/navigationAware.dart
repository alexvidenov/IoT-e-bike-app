import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:flutter/cupertino.dart';

// can only be mixed with Stateful widgets
mixin Navigation implements StatefulWidget {
  final NavigationBloc navigationBloc = $<NavigationBloc>();
}

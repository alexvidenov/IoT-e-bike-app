import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';

typedef NotifyLocation = Function(CurrentPage);

// can only be mixed with Stateful widgets
mixin Navigation implements StatefulWidget {
  NavigationBloc get navigationBloc =>
      $<NavigationBloc>(); // prolly extract only the function
}

@optionalTypeArgs
mixin RouteUtils<T extends Bloc<dynamic, dynamic>> on RouteAwareWidget<T> {
  Function(String) get to => $<NavigationBloc>().to;

  Function() get toFirst => $<NavigationBloc>().returnToFirstRoute;

  NotifyLocation get notifyForRoute => $<NavigationBloc>().addEvent;
}

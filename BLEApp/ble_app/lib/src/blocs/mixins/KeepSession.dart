import 'package:ble_app/src/screens/routeAware.dart';
import 'package:flutter/cupertino.dart';

import '../../blocs/shortStatusBloc.dart';
import '../../di/serviceLocator.dart';
import '../bloc.dart';

typedef _KeepSessionCallback = dynamic Function();

typedef _Pause = dynamic Function();

@optionalTypeArgs
// can only be mixed with Route Aware's
mixin KeepSession<T extends Bloc<dynamic, dynamic>> on RouteAwareWidget<T> {
  final ShortStatusBloc shortStatusBloc = $<ShortStatusBloc>();

  _KeepSessionCallback get keepSession => () {
        shortStatusBloc.create();
        shortStatusBloc.resume();
      };

  _Pause get pause => () {
        shortStatusBloc.pause();
      };
}

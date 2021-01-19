import 'package:ble_app/src/screens/routeAware.dart';

import '../../blocs/shortStatusBloc.dart';
import '../../di/serviceLocator.dart';
import '../bloc.dart';

typedef _KeepSessionCallback = dynamic Function();

// can only be mixed with Route Aware's
mixin KeepSession<T extends Bloc<dynamic, dynamic>>
    implements RouteAwareWidget<T> {
  _KeepSessionCallback get keepSession => () {
        $<ShortStatusBloc>().create();
        $<ShortStatusBloc>().resume();
      };
}

import 'package:ble_app/src/screens/routeAware.dart';

import '../../blocs/shortStatusBloc.dart';
import '../../di/serviceLocator.dart';
import '../bloc.dart';

typedef _KeepSessionCallback = dynamic Function();

mixin KeepSession<T extends Bloc<dynamic, dynamic>>
    implements RouteAwareWidget<T> {
  final _KeepSessionCallback keepSession = () {
    $<ShortStatusBloc>().create();
    $<ShortStatusBloc>().resume();
  };
}

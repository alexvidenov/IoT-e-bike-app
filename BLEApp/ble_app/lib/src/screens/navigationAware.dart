import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';

mixin NavigationAware {
  final NavigationBloc navigationBloc = $<NavigationBloc>();
}

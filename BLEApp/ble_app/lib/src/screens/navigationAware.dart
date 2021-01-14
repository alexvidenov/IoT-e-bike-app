import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';

// constraint this mixin as well
mixin Navigation {
  final NavigationBloc navigationBloc = $<NavigationBloc>();
}

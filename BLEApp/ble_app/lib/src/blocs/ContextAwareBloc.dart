import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/bloc.dart';

abstract class ContextAwareBloc<T, S> extends Bloc<T, S> with CurrentContext {}

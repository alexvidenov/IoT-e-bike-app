import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterAware.dart';

import '../bloc.dart';

abstract class ParameterAwareBloc<T, S> extends Bloc<T, S> with ParameterAware {
}

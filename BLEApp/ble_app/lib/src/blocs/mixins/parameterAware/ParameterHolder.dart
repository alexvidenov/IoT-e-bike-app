import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../bloc.dart';

@lazySingleton
class ParameterHolder
    extends Bloc<DeviceParametersModel, DeviceParametersModel> {}

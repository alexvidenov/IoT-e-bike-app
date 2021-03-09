import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterAware.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';

import '../bloc.dart';

abstract class ParameterAwareBloc<T, S> extends Bloc<T, S>
    with ParameterAware, CurrentContext {
  final _dbManager = $<LocalDatabaseManager>();

  void cacheParameters() => _dbManager.insertParameters(currentParams);

  void updateParameters({DeviceParameters model}) =>
      _dbManager.updateParameter(model);

  void setLocalParameters(DeviceParameters parameters) =>
      currentParams = parameters;

  void updateMotoHours(int chargeHours, int dischargeHours) =>
      this.setLocalParameters(currentParams.copyWith(
          motoHoursChargeCounter: chargeHours,
          motoHoursDischargeCounter: dischargeHours));

  Stream<DeviceParameters> parametersAsStream() => _dbManager.fetchParameters();

  Future<DeviceParameters> parametersAsFuture() =>
      _dbManager.fetchParametersAsFuture();
}

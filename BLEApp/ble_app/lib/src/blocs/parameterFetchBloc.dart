import 'dart:collection';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/LocalDatabaseManager.dart';
import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterHolder.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/sealedStates/parameterFetchState.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/connectivityManager.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

@injectable
class ParameterFetchBloc extends Bloc<ParameterFetchState, String>
    with CurrentContext {
  final DeviceRepository _repository;
  final ParameterHolder _holder;
  final LocalDatabaseManager _dbManager;

  ParameterFetchBloc(this._repository, this._holder, this._dbManager)
      : super(); // can be const as well

  final _parameters = SplayTreeMap<String, double>();

  @override
  create() async {
    super.create();
    addEvent(ParameterFetchState.fetching());
    queryParameters();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      print('PARAMETER EVENT: ' + event);
      final buffer = StringBuffer();
      for (var i = 3; i < event.length; i++) {
        buffer.write('${event[i]}');
      }
      final value = double.parse(buffer.toString());
      print('Parameter: ' + value.toString());
      _parameters['${event[1]}' + '${event[2]}'] = value;
    });
  }

  cacheParameters(DeviceParameters parameters) {
    print('Device parameters are:' + parameters.toString());
    _dbManager.insertParameters(parameters);
    _holder.deviceParameters.value = parameters;
  }
}

extension FetchParams on ParameterFetchBloc {
  queryParameters() async {
    for (var i = 0; i < 7; i++) await _querySingleParam('R0$i\r');
    for (var i = 12; i < 18; i++) await _querySingleParam('R$i\r');
    for (var i = 23; i < 27; i++) await _querySingleParam('R$i\r');
    await _querySingleParam('R28\r');
    await _querySingleParam('R29\r');
    Future.delayed(Duration(milliseconds: 150), () async {
      // was 100, try to vary that
      if (_parameters.keys.length == 19) {
        //final db = FirestoreDatabase(uid: $<AuthBloc>().user);
        //if (!(await db.parametersExist(deviceId: _repository.deviceId))) {
        if (await ConnectivityManager.isOnline()) {
          FirestoreDatabase(uid: this.curUserId, deviceId: this.curDeviceId)
              .setDeviceParameters(_parameters);
        }
        final entity = DeviceParameters(
            id: this.curDeviceId,
            cellCount: _parameters['00'].toInt(),
            maxCellVoltage: _parameters['01'],
            maxRecoveryVoltage: _parameters['02'],
            balanceCellVoltage: _parameters['03'],
            minCellVoltage: _parameters['04'],
            minCellRecoveryVoltage: _parameters['05'],
            ultraLowCellVoltage: _parameters['06'],
            maxTimeLimitedDischargeCurrent: _parameters['12'],
            maxCutoffDischargeCurrent: _parameters['13'],
            maxCurrentTimeLimitPeriod: _parameters['14'].toInt(),
            maxCutoffChargeCurrent: _parameters['15'],
            motoHoursCounterCurrentThreshold: _parameters['16'].toInt(),
            currentCutOffTimerPeriod: _parameters['17'].toInt(),
            maxCutoffTemperature: _parameters['23'].toInt(),
            maxTemperatureRecovery: _parameters['24'].toInt(),
            minTemperatureRecovery: _parameters['25'].toInt(),
            minCutoffTemperature: _parameters['26'].toInt(),
            motoHoursChargeCounter: _parameters['28'].toInt(),
            motoHoursDischargeCounter: _parameters['29'].toInt());
        //}
        addEvent(ParameterFetchState.fetched(entity));
      } else
        queryParameters();
      //queryParameters();
    });
  }

  Future<void> _querySingleParam(String command) async => await Future.delayed(
      Duration(milliseconds: 100),
      () => _repository.writeToCharacteristic(command));
}

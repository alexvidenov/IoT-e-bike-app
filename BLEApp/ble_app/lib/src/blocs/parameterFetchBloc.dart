import 'dart:collection';

import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/sealedStates/parameterFetchState.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:ble_app/src/utils/connectivityManager.dart';
import 'package:injectable/injectable.dart';

@injectable
class ParameterFetchBloc
    extends ParameterAwareBloc<ParameterFetchState, String> {
  final DeviceRepository _repository;

  final tempConverter = TemperatureConverter();

  ParameterFetchBloc(this._repository) : super();

  final _parameters = SplayTreeMap<String, double>();

  @override
  create() async {
    super.create();
    final params = await parametersAsFuture();
    if (params != null) {
      setLocalParameters(params);
      addEvent(ParameterFetchState.fetched(params));
    } else {
      addEvent(ParameterFetchState.fetching());
      queryParameters();
      streamSubscription =
          _repository.characteristicValueStream.listen((event) {
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
      if (_parameters.keys.length >= 19) {
        final entity = DeviceParameters(
            id: curDeviceId,
            cellCount: _parameters['00'].toInt(),
            maxCellVoltage: _parameters['01'] / 100,
            maxRecoveryVoltage: _parameters['02'] / 100,
            balanceCellVoltage: _parameters['03'] / 100,
            minCellVoltage: _parameters['04'] / 100,
            minCellRecoveryVoltage: _parameters['05'] / 100,
            ultraLowCellVoltage: _parameters['06'] / 100,
            maxTimeLimitedDischargeCurrent: _parameters['12'] / 100,
            maxCutoffDischargeCurrent: _parameters['13'] / 100,
            maxCurrentTimeLimitPeriod: _parameters['14'].toInt(),
            maxCutoffChargeCurrent: _parameters['15'] / 100,
            motoHoursCounterCurrentThreshold: _parameters['16'].toInt(),
            currentCutOffTimerPeriod: _parameters['17'].toInt(),
            maxCutoffTemperature:
                tempConverter.tempFromADC(_parameters['23'].toInt()),
            maxTemperatureRecovery:
                tempConverter.tempFromADC(_parameters['24'].toInt()),
            minTemperatureRecovery:
                tempConverter.tempFromADC(_parameters['25'].toInt()),
            minCutoffTemperature:
                tempConverter.tempFromADC(_parameters['26'].toInt()),
            motoHoursChargeCounter: _parameters['28'].toInt(),
            motoHoursDischargeCounter: _parameters['29'].toInt());
        setLocalParameters(entity);
        cacheParameters();
        addEvent(ParameterFetchState.fetched(entity));
      } else
        queryParameters();
    });
  }

  Future<void> _querySingleParam(String command) async => await Future.delayed(
      Duration(milliseconds: 100),
      () => _repository.writeToCharacteristic(command));
}

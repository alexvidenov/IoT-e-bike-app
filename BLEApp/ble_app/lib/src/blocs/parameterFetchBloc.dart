import 'dart:collection';

import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/sealedStates/parameterFetchState.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:injectable/injectable.dart';

@injectable
class ParameterFetchBloc
    extends ParameterAwareBloc<ParameterFetchState, String> {
  final DeviceRepository _repository;

  final tempConverter = TemperatureConverter();

  ParameterFetchBloc(this._repository) : super();

  final _parameters = SplayTreeMap<String, double>();

  DeviceParameters _model;

  int _retryCounter = 0;

  @override
  create() async {
    super.create();
    addEvent(ParameterFetchState.fetching());
    final params = await parametersAsFuture();
    _model = params;
    if (params != null) {
      setLocalParameters(params);
      queryMotoHours();
    } else {
      queryParameters();
    }
    _listen();
  }

  void _listen() => streamSubscription =
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

extension FetchParams on ParameterFetchBloc {
  Future<void> queryParameters() async {
    for (var i = 0; i < 7; i++) await _querySingleParam('R0$i\r');
    for (var i = 12; i < 18; i++) await _querySingleParam('R$i\r');
    for (var i = 23; i < 27; i++) await _querySingleParam('R$i\r');
    await _querySingleParam('R28\r');
    await _querySingleParam('R29\r');
    await _querySingleParam('R50\r'); // final int cell count
    Future.delayed(Duration(milliseconds: 150), () async {
      if (_parameters.keys.length >= 20) {
        final entity = DeviceParameters(
            id: curDeviceId,
            cellCount: _parameters['50'].toInt(),
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
            motoHoursCounterCurrentThreshold: _parameters['16'] / 100,
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
      } else {
        _retryCounter++;
        if (_retryCounter == 3) {
          // addEvent that says the fetch was incomplete. And offer restart.
        }
        queryParameters(); // FIXME: Instead of looping forever, abort after three iterations here
      }
    });
  }

  Future<void> queryMotoHours() async {
    await _querySingleParam('R28\r');
    await _querySingleParam('R29\r');
    Future.delayed(Duration(milliseconds: 150), () {
      print('KEYS ARE: ' + _parameters.keys.length.toString());
      if (_parameters.keys.length >= 3) {
        print('MOTO HOURS ADDED');
        updateMotoHours(_parameters['28'].toInt(), _parameters['29'].toInt());
        addEvent(ParameterFetchState.fetched(_model));
      } else {
        _parameters.clear();
        queryMotoHours();
      }
    });
  }

  Future<void> _querySingleParam(String command) async => await Future.delayed(
      Duration(milliseconds: 100),
      () => _repository.writeToCharacteristic(command));
}

import 'dart:collection';

import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterHolder.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:ble_app/src/sealedStates/ParameterFetchState.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

@injectable
class DeviceParametersBloc extends Bloc<ParameterFetchState, String> {
  final DeviceRepository _repository;
  final ParameterHolder _holder;

  DeviceParametersBloc(this._repository, this._holder) : super();

  var _parameters = SplayTreeMap<String, double>();

  @override
  create() {
    super.create();
    addEvent(ParameterFetchState.fetching());
    queryParameters();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      addState(event);
    });
  }

  @override
  pause() => pauseSubscription();

  @override
  resume() => resumeSubscription();

  queryParameters() async {
    for (var i = 0; i < 7; i++) {
      await _querySingleParam('R0$i');
    }
    for (var i = 12; i < 18; i++) {
      await _querySingleParam('R$i');
    }
    for (var i = 23; i < 27; i++) {
      await _querySingleParam('R$i');
    }
  }

  _querySingleParam(String command) async => await Future.delayed(
      Duration(milliseconds: 80),
      () => _repository.writeToCharacteristic(command));

  setParameters(DeviceParametersModel parameters) =>
      _holder.deviceParameters = parameters;

  @override
  ParameterFetchState mapEventToState(String event) {
    print('PARAMETER EVENT: ' + event);
    var buffer = StringBuffer();
    for (var i = 3; i < event.length; i++) {
      buffer.write('${event[i]}');
    }
    final value = double.parse(buffer.toString());
    print('Parameter: ' + value.toString());

    String command = '${event[1]}' + '${event[2]}';
    _parameters[command] = value;

    if (command == '26')
      addEvent(ParameterFetchState.fetched(
          parameters: DeviceParametersModel(
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
              minCutoffTemperature: _parameters['26'].toInt())));
  }
}

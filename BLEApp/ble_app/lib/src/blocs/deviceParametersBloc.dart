import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/sealedStates/ParameterFetchState.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

@injectable
class DeviceParametersBloc extends Bloc<ParameterFetchState, String> {
  final DeviceRepository _repository;
  final SettingsBloc _settingsBloc;

  DeviceParametersBloc(this._repository, this._settingsBloc) : super();

  DeviceParametersModel _deviceParametersModel;

  int _cellCount;

  double _maxCellVoltage;
  double _maxRecoveryVoltage;
  double _balanceCellVoltage;
  double _minCellVoltage;
  double _minCellRecoveryVoltage;
  double _ultraLowCellVoltage;

  double _maxTimeLimitedDischargeCurrent;
  double _maxCutoffDischargeCurrent;
  int _maxCurrentTimeLimitPeriod;
  double _maxCutoffChargeCurrent;
  int _motoHoursCounterCurrentThreshold;
  int _currentCutOffTimerPeriod;

  int _maxCutoffTemperature;
  int _maxTemperatureRecovery;
  int _minTemperatureRecovery;
  int _minCutoffTemperature;

  @override
  create() {
    super.create();
    addEvent(ParameterFetchState.fetching());
    queryParameters();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      print('PARAMETER EVENT: ' + event);
      var buffer = StringBuffer();
      for (var i = 3; i < event.length; i++) {
        buffer.write('${event[i]}');
      }
      final value = double.parse(buffer.toString());
      print('Parameter: ' + value.toString());
      switch ('${event[1]}' + '${event[2]}') {
        // R010428 -> we get 01
        case '00':
          _cellCount = value.toInt();
          break;
        case '01':
          _maxCellVoltage = value;
          break;
        case '02':
          _maxRecoveryVoltage = value;
          break;
        case '26':
          _minCutoffTemperature = value.toInt();
          printStuff();
          break;
        //addEvent(
        //ParameterFetchState.fetched(parameters: _deviceParametersModel));
        // _settingsBloc.saveParameters();
      }
    });
  }

  printStuff() {
    print('Cell count: ' + _cellCount.toString() + '\n');
    print('Max cell voltage ' + _maxCellVoltage.toString() + '\n');
    print('Max recovery voltage ' + _maxRecoveryVoltage.toString() + '\n');
    print('Max cutoff temperature ' + _minCutoffTemperature.toString() + '\n');
  }

  @override
  pause() => pauseSubscription();

  @override
  resume() => resumeSubscription();

  queryParameters() {
    Future.delayed(Duration(milliseconds: 80), () {
      _repository.writeToCharacteristic('R00\r');
    }).then((_) => Future.delayed(Duration(milliseconds: 80), () {
          _repository.writeToCharacteristic('R01\r');
        })
            .then((_) => Future.delayed(Duration(milliseconds: 80), () {
                  _repository.writeToCharacteristic('R02\r');
                }))
            .then((_) => Future.delayed(Duration(milliseconds: 80), () {
                  _repository.writeToCharacteristic('R26\r');
                }))); // think of delay between calls if necessary
  }
}

import 'package:ble_app/src/blocs/blocExtensions/ParameterAwareBloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

enum ParameterChangeStatus { Successful, Unsuccessful }

enum CalibrateType { Voltage, Charge, Discharge }

extension CalibrateStringCommand on CalibrateType {
  String getStringCommand() {
    switch (this) {
      case CalibrateType.Voltage:
        return 'V';
      case CalibrateType.Charge:
        return 'C';
      case CalibrateType.Discharge:
        return 'D';
      default:
        return 'Error'; // can't get to here
    }
  }
}

@injectable
class ParameterListenerBloc
    extends ParameterAwareBloc<ParameterChangeStatus, String> {
  final DeviceRepository _repository;

  ParameterListenerBloc(this._repository) : super();

  String currentKey; // TODO: extract in an object
  String currentValue;

  bool _successful = false;

  int _changingNumOfCells = 0;

  @override
  create() {
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      if (event.startsWith('OK')) {
        _successful = true;
        if (currentKey == '00') {
          _changingNumOfCells++;
          if (_changingNumOfCells == 2) {
            _changingNumOfCells = 0;
            addEvent(ParameterChangeStatus.Successful);
          }
        } else
          addEvent(ParameterChangeStatus.Successful);
        DeviceParameters newModel;
        switch (currentKey) {
          case '00':
            newModel =
                currentParams.copyWith(cellCount: int.parse(currentValue));
            break;
          case '01':
            newModel = currentParams.copyWith(
                maxCellVoltage: double.parse(currentValue));
            break;
          case '02':
            newModel = currentParams.copyWith(
                maxRecoveryVoltage: double.parse(currentValue));
            break;
          case '03':
            newModel = currentParams.copyWith(
                balanceCellVoltage: double.parse(currentValue));
            break;
          case '04':
            newModel = currentParams.copyWith(
                minCellVoltage: double.parse(currentValue));
            break;
          case '05':
            newModel = currentParams.copyWith(
                minCellRecoveryVoltage: double.parse(currentValue));
            break;
          case '06':
            newModel = currentParams.copyWith(
                ultraLowCellVoltage: double.parse(currentValue));
            break;
          case '12':
            newModel = currentParams.copyWith(
                maxTimeLimitedDischargeCurrent: double.parse(currentValue));
            break;
          case '13':
            newModel = currentParams.copyWith(
                maxCutoffDischargeCurrent: double.parse(currentValue));
            break;
          case '14':
            newModel = currentParams.copyWith(
                maxCurrentTimeLimitPeriod: int.parse(currentValue));
            break;
          case '15':
            newModel = currentParams.copyWith(
                maxCutoffChargeCurrent: double.parse(currentValue));
            break;
          case '16':
            newModel = currentParams.copyWith(
                motoHoursCounterCurrentThreshold: double.parse(currentValue));
            break;
          case '17':
            newModel = currentParams.copyWith(
                currentCutOffTimerPeriod: int.parse(currentValue));
            break;
          case '23':
            newModel = currentParams.copyWith(
                maxCutoffTemperature: int.parse(currentValue));
            break;
          case '24':
            newModel = currentParams.copyWith(
                maxTemperatureRecovery: int.parse(currentValue));
            break;
          case '25':
            newModel = currentParams.copyWith(
                minTemperatureRecovery: int.parse(currentValue));
            break;
          case '26':
            newModel = currentParams.copyWith(
                minCutoffTemperature: int.parse(currentValue));
            break;
          case '28':
            newModel = currentParams.copyWith(
                motoHoursChargeCounter: int.parse(currentValue));
            break;
          case '29':
            newModel = currentParams.copyWith(
                motoHoursDischargeCounter: int.parse(currentValue));
            break;
        }
        final num numValue = num.parse(currentValue);
        if (newModel != null) {
          FirestoreDatabase(uid: this.curUserId, deviceId: this.curDeviceId)
              .updateIndividualParameter(currentKey, numValue);
          updateParameters(model: newModel);
          setLocalParameters(newModel);
        }
      }
    });
  }

  void changeParameter(String key, String value) {
    final String command = _generateCommandString(key, value);
    _successful = false;
    _timeout();
    _repository.writeToCharacteristic(command);
    currentKey = key;
    this.currentValue = value;
  }

  void _calibrate({CalibrateType calibrateType}) {
    _successful = false;
    _timeout();
    final command = calibrateType.getStringCommand();
    _repository.writeToCharacteristic('$command\r');
  }

  void calibrateVoltage() => _calibrate(calibrateType: CalibrateType.Voltage);

  void calibrateCharge() => _calibrate(calibrateType: CalibrateType.Charge);

  void calibrateDischarge() =>
      _calibrate(calibrateType: CalibrateType.Discharge);

  void _programNumOfCells(String value, {int node, String reminderValue}) {
    _successful = false;
    _timeout();
    _repository.writeToCharacteristic('W000$node' + '0$reminderValue\r');
    currentKey = '00';
    this.currentValue = value;
  }

  void programNumOfCellsFirstNode(String value, {String reminderValue}) =>
      _programNumOfCells(value, node: 1, reminderValue: reminderValue);

  void programNumOfCellsSecondNode(String value,
          {String reminderValue = '3'}) =>
      _programNumOfCells(value, node: 2, reminderValue: reminderValue);

  void _timeout() => Future.delayed(Duration(milliseconds: 900), () {
        if (!_successful) addEvent(ParameterChangeStatus.Unsuccessful);
      });

  void retry() {
    final String command =
        _generateCommandString(this.currentKey, currentValue);
    _repository.writeToCharacteristic(command);
  }

  Stream<DeviceParameters> get parameters => parametersAsStream();
}

extension ParseParameterString on ParameterListenerBloc {
  String _generateCommandString(String key, String value) {
    final keyInt = int.parse(key);
    if (keyInt >= 1 && keyInt <= 16 && keyInt != 14) {
      value = (double.parse(value) * 100).toInt().toString();
    }
    if (keyInt >= 23 && keyInt <= 26) {
      value = TemperatureConverter().adcFromTemp(int.parse(value)).toString();
    }
    switch (value.length) {
      case 1:
        value = '000$value';
        break;
      case 2:
        value = '00$value';
        break;
      case 3:
        value = '0$value';
        break;
      default:
        break;
    }
    return 'W$key$value\r';
  }
}

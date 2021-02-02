import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterHolder.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

enum ParameterChangeStatus { Successful, Unsuccessful }

@injectable
class ParameterListenerBloc extends Bloc<ParameterChangeStatus, String>
    with CurrentContext {
  final DeviceRepository _repository;
  final ParameterHolder _parameterHolder;
  final LocalDatabaseManager _dbManager;

  ParameterListenerBloc(
      this._repository, this._parameterHolder, this._dbManager);

  String currentKey; // TODO: extract in an object
  String value;

  bool _successful = false;

  @override
  create() {
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      print('RESPONSE FROM PARAM LISTENER: $event');
      if (event.startsWith('OK')) {
        _successful = true;
        addEvent(ParameterChangeStatus
            .Successful); // in the UI, wait 1 second if not successful
        DeviceParameters newModel;
        switch (currentKey) {
          case '01':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(maxCellVoltage: double.parse(value));
            break;
          case '02':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(maxRecoveryVoltage: double.parse(value));
            break;
          case '03':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(balanceCellVoltage: double.parse(value));
            break;
          case '04':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(minCellVoltage: double.parse(value));
            break;
          case '05':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(minCellRecoveryVoltage: double.parse(value));
            break;
          case '06':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(ultraLowCellVoltage: double.parse(value));
            break;
          case '12':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(maxTimeLimitedDischargeCurrent: double.parse(value));
            break;
          case '13':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(maxCutoffDischargeCurrent: double.parse(value));
            break;
          case '14':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(maxCurrentTimeLimitPeriod: int.parse(value));
            break;
          case '15':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(maxCutoffChargeCurrent: double.parse(value));
            break;
          case '16':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(motoHoursCounterCurrentThreshold: int.parse(value));
            break;
          case '17':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(currentCutOffTimerPeriod: int.parse(value));
            break;
          case '23':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(maxCutoffTemperature: int.parse(value));
            break;
          case '24':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(maxTemperatureRecovery: int.parse(value));
            break;
          case '25':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(minTemperatureRecovery: int.parse(value));
            break;
          case '26':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(minCutoffTemperature: int.parse(value));
            break;
          case '28':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(motoHoursChargeCounter: int.parse(value));
            break;
          case '29':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(motoHoursDischargeCounter: int.parse(value));
            break;
        }
        num numValue = num.parse(value);
        FirestoreDatabase(uid: this.curUserId, deviceId: this.curDeviceId)
            .setIndividualParameter(currentKey, numValue);
        _dbManager.updateParameter(newModel);
        if (newModel != null)
          _parameterHolder.deviceParameters.value = newModel;
        // TODO; add method in the data class to parse stuff and return
        // enum with the available parameters (?). actually needed only for specific stuff
      }
    });
  }

  changeParameter(String key, String value) {
    final String command = _generateCommandString(key, value);
    print('EXECUTING COMMANd => $command');
    _successful = false;
    _timeout();
    _repository.writeToCharacteristic(command);
    currentKey = key;
    this.value = value;
  }

  _timeout() => Future.delayed(Duration(milliseconds: 500), () {
        if (!_successful) addEvent(ParameterChangeStatus.Unsuccessful);
      });

  retry() {
    final String command = _generateCommandString(this.currentKey, value);
    _repository.writeToCharacteristic(command);
  }

  Stream<DeviceParameters> get parameters => _dbManager.fetchParameters();
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

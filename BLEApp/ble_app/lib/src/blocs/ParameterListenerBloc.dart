import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/blocs/LocalDatabaseManager.dart';
import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterHolder.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

enum ChangeStatus { Successful, Unsuccessful }

@injectable
class ParameterListenerBloc extends Bloc<ChangeStatus, String>
    with CurrentContext {
  final DeviceRepository _repository;
  final ParameterHolder _parameterHolder;
  final LocalDatabaseManager _dbManager;

  ParameterListenerBloc(
      this._repository, this._parameterHolder, this._dbManager);

  String currentCommand; // updated every time a parameter is changed

  @override
  create() {
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      print('RESPONSE FROM PARAM LISTENER: $event');
      if (event.startsWith('OK')) {
        addEvent(ChangeStatus
            .Successful); // in the UI, wait 1 second if not successful
        String key = '${currentCommand[1] + currentCommand[2]}';
        String value =
            '${currentCommand[3] + currentCommand[4] + currentCommand[5] + currentCommand[6]}';
        DeviceParameters newModel;
        switch (key) {
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
        //num numValue = num.parse(value);
        //print(newModel.maxTemperatureRecovery);
        //FirestoreDatabase(uid: this.curUserId, deviceId: this.curDeviceId)
        // .setIndividualParameter(key, numValue);
        //_firestoreDatabase.setIndividualParameter(
        // key, numValue); // this will stay here
        print(newModel.id);
        _dbManager.updateParameter(newModel);
        if (newModel != null)
          _parameterHolder.deviceParameters.value = newModel;
        // TODO; add method in the data class to parse stuff and return
        // enum with the available parameters (?). actually needed only for specific stuff
      }
    });
  }

  changeParameter(String command) {
    // TODO: write the command pattern here instead of from the UI
    currentCommand = command;
    _repository.writeToCharacteristic(command);
  }

  Stream<DeviceParameters> get parameters => _dbManager.fetchParameters();
}

extension ParseParameterString on ParameterListenerBloc {}

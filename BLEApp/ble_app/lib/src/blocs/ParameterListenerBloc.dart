import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterHolder.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

enum ChangeStatus { Successful, Unsuccessful }

@injectable
class ParameterListenerBloc extends Bloc<ChangeStatus, String> {
  final DeviceRepository _repository;
  final ParameterHolder _parameterHolder;
  final FirestoreDatabase _firestoreDatabase;
  final LocalDatabase _localDatabase;

  ParameterListenerBloc(
      this._repository, this._parameterHolder, this._localDatabase)
      : this._firestoreDatabase = FirestoreDatabase(
            uid: $<Auth>().getCurrentUserId(), deviceId: _repository.deviceId);

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
            newModel = _parameterHolder.deviceParameters.value.copyWith(
                maxCellVoltage: double.parse(value), maxCutoffTimePeriod: 4);
            break;
          case '03':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(balanceCellVoltage: double.parse(value));
            break;
          case '04':
            newModel = _parameterHolder.deviceParameters.value
                .copyWith(minCellVoltage: double.parse(value));
            break;
        }
        num numValue = num.parse(value);
        print(newModel.maxTemperatureRecovery);
        //_firestoreDatabase.setIndividualParameter(
        // key, numValue); // this will stay here
        _localDatabase.parametersDao.updateEntity(newModel);
        if (newModel != null)
          _parameterHolder.deviceParameters.value = newModel;
        // TODO; add method in the data class to parse stuff and return
        // enum with the available parameters (?). actually needed only for specific stuff
      }
    });
  }

  changeParameter(String command) {
    currentCommand = command;
    _repository.writeToCharacteristic(command);
  }

  Stream<DeviceParameters> get parameters =>
      _localDatabase.parametersDao.fetchDeviceParameters(_repository.deviceId);
}

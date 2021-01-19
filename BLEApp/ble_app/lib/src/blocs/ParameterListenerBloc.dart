import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

enum ChangeStatus { Successful, Unsuccessful }

@injectable
class ParameterListenerBloc extends Bloc<ChangeStatus, String> {
  final DeviceRepository _repository;
  final FirestoreDatabase _firestoreDatabase;

  ParameterListenerBloc(this._repository)
      : this._firestoreDatabase = FirestoreDatabase(
            uid: $<Auth>().getCurrentUserId(), deviceId: _repository.deviceId);

  @override
  create() {
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      // FIXME will have to listen to a custom stream
      print('RESPONSE FROM PARAM LISTENER: $event');
      if (event.startsWith('W')) {
        addEvent(ChangeStatus
            .Successful); // in the UI, wait 1 second if not successful
        String key = '${event[1]}' + '${event[2]}';
        String value =
            '${event[3]}' + '${event[4]}' + '${event[5]}' + '${event[6]}';
        num numValue = num.parse(value);
        _firestoreDatabase.setIndividualParameter(key, numValue);
      }
    });
  }

  changeParameter(String command) => _repository.writeToCharacteristic(command);

  Stream<DocumentSnapshot> get parameters =>
      _firestoreDatabase.deviceParameters;
}

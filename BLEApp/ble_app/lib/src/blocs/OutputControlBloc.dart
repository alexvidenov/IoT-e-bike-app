import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

enum OutputsState { On, Off }

@injectable
class OutputControlBloc extends Bloc<OutputsState, String> {
  final DeviceRepository _repository;

  OutputControlBloc(this._repository) : super();

  var curOutputsState;

  @override
  create() {
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      if (event.startsWith('OK')) {
        if (curOutputsState != null) addEvent(curOutputsState);
      }
    });
  }

  on() {
    curOutputsState = OutputsState.On;
    _repository.writeToCharacteristic('O1\r');
  }

  off() {
    curOutputsState = OutputsState.Off;
    _repository.writeToCharacteristic('O0\r');
  }
}

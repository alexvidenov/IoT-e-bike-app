import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

enum OutputsState { On, Off }

@singleton
class OutputControlBloc extends Bloc<OutputsState, String> {
  final DeviceRepository _repository;

  OutputControlBloc(this._repository) : super();

  var curOutputsState = OutputsState.Off;

  @override
  create() => streamSubscription =
          _repository.characteristicValueStream.listen((event) {
        if (event.startsWith('OK')) {
          if (curOutputsState != null) addEvent(curOutputsState);
        }
      });

  void on() {
    curOutputsState = OutputsState.On;
    _repository.writeToCharacteristic('O1\r');
  }

  void off() {
    curOutputsState = OutputsState.Off;
    _repository.writeToCharacteristic('O0\r');
  }

  bool isDeviceManuallyLocked() => curOutputsState == OutputsState.On;
}

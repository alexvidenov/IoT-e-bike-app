import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/persistence/entities/deviceState.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

enum OutputsState { On, Off }

@lazySingleton
class OutputControlBloc extends Bloc<OutputsState, String> with CurrentContext {
  final DeviceRepository _repository;
  final LocalDatabaseManager _db;

  OutputControlBloc(this._repository, this._db) : super();

  var curOutputsState = OutputsState.Off;

  @override
  create() {
    _generateInitialState();
    streamSubscription =
        _repository.characteristicValueStream.listen((event) async {
      if (event.startsWith('OK')) {
        print('Calling THE OUTPUT CONTROL : $curOutputsState');
        if (curOutputsState != null) {
          addEvent(curOutputsState);
          await _db.updateDeviceState(DeviceState(
              deviceNumber: this.curDeviceId,
              isBatteryOn: curOutputsState == OutputsState.Off));
        }
      }
    });
  }

  Future<void> _generateInitialState() async {
    final _deviceState = await _db.fetchDeviceState();
    print("Initial deviceState is" + _deviceState.isBatteryOn.toString());
    final isOn = _deviceState.isBatteryOn;
    if (isOn == true) {
      curOutputsState = OutputsState.Off;
    } else {
      print('ITS ON WTF');
      curOutputsState = OutputsState.On;
    }
    addEvent(curOutputsState);
  }

  void on() {
    // LOCKS THE DEVICE
    print("LOCKING");
    curOutputsState = OutputsState.On;
    _repository.writeToCharacteristic('O1\r');
  }

  void off() {
    // UNLOCKS
    print("UNLOCKING");
    curOutputsState = OutputsState.Off;
    _repository.writeToCharacteristic('O0\r');
  }

  bool isDeviceManuallyLocked() =>
      curOutputsState == OutputsState.On; // CHECKED WHEN STATUS BYTE IS 4
}

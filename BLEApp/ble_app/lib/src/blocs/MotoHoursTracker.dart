import 'dart:async';
import 'dart:collection';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:injectable/injectable.dart';

import 'RxObject.dart';

@injectable
class MotoHoursTracker extends Bloc<List<double>, String> {
  final DeviceRepository _repository;

  Timer _timer;

  MotoHoursTracker(this._repository) : super();

  final isReady = RxObject<bool>();

  void init() {
    isReady.addEvent(false);
    fetchMotoHours();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      fetchMotoHours();
    });
  }

  final _parameters = SplayTreeMap<String, double>();

  @override
  create() {
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      print('PARAMETER EVENT: ' + event);
      if (event.startsWith('R2')) {
        // makes sure to not interfere with the last emitted password
        final buffer = StringBuffer();
        for (var i = 3; i < event.length; i++) {
          buffer.write('${event[i]}');
        }
        final value = double.parse(buffer.toString());
        _parameters['${event[1]}' + '${event[2]}'] = value;
        print('Parameter: ' + value.toString());
      }
    });
  }

  void pauseTimer() => _timer.cancel();

  Future<void> _querySingleParam(String command) async => await Future.delayed(
      Duration(milliseconds: 80),
      () => _repository.writeToCharacteristic(command));

  Future<void> fetchMotoHours() async {
    create();
    _repository.cancel();
    print('FETCHING MOTO HOURS' + DateTime.now().toString());
    await _querySingleParam('R28\r');
    await _querySingleParam('R29\r');
    Future.delayed(Duration(milliseconds: 150), () {
      print('KEYS ARE: ' + _parameters.keys.length.toString());
      if (_parameters.keys.length >= 2) {
        pause();
        isReady.addEvent(true);
        _repository.resume();
        print('MOTO HOURS ADDED');
        addEvent([_parameters['28'], _parameters['29']]);
        _parameters.clear();
      } else
        fetchMotoHours(); // prolly clear the parameters again here
    });
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

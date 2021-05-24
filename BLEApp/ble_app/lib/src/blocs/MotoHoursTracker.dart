import 'dart:async';
import 'dart:collection';

import 'package:ble_app/src/blocs/base/ParameterAwareBloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:injectable/injectable.dart';

@injectable
class MotoHoursTracker extends ParameterAwareBloc<void, String> {
  final DeviceRepository _repository;

  Timer _timer;

  MotoHoursTracker(this._repository) : super();

  void init() => _startTimer();

  void _startTimer() =>
      _timer = Timer.periodic(Duration(seconds: 20), (_) => fetchMotoHours());

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

  void cancelTimer() => _timer.cancel();

  Future<void> _querySingleParam(String command) async => await Future.delayed(
      Duration(milliseconds: 80),
      () => _repository.writeToCharacteristic(command));

  Future<void> fetchMotoHours() async {
    // TODO: execute a callback to the full status to pause its subscription (?)
    streamSubscription?.cancel();
    create();
    _repository.cancel();
    print('FETCHING MOTO HOURS' + DateTime.now().toString());
    await _querySingleParam('R28\r');
    await _querySingleParam('R29\r');
    Future.delayed(Duration(milliseconds: 300), () {
      print('KEYS ARE: ' + _parameters.keys.length.toString());
      if (_parameters.keys.length >= 2) {
        pause();
        _repository.resume();
        print('MOTO HOURS ADDED');
        updateMotoHours(_parameters['28'].toInt(), _parameters['29'].toInt());
        _parameters.clear();
      } else {
        pause();
        fetchMotoHours(); // prolly clear the parameters again here. FIXME this is eternal
      }
    });
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

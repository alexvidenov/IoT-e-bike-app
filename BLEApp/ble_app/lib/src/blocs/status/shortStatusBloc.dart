import 'dart:async';

import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/WattCollector.dart';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';

import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:injectable/injectable.dart';

import '../base/StateBloc.dart';

@injectable
class ShortStatusBloc extends StateBloc<ShortStatus, ShortLogmodel>
    with OnTrackStarted {
  final DeviceRepository _repository;
  final WattCollector _wattCollector;

  final tempConverter = TemperatureConverter();

  int _uploadTimer = 0;

  final List<double> _collectedWatts = [];

  Timer _wattCollectionTimer;

  bool _shouldCollectWatts = false;

  ShortStatusBloc(this._repository, this._wattCollector)
      : super(); // TODO: inject something to determine whether to collect user data or not (?)

  @override
  pause() {
    super.pause();
    logger.wtf('PAUSING IN SHORT STATUS BLOC');
  }

  @override
  resume() {
    super.resume();
    logger.wtf('RESUMING IN SHORT STATUS BLOC');
    _repository.resumeTimer(true);
  }

  @override
  create() {
    logger.wtf('CREATING IN SHORT STATUS BLOC');
    _wattCollector.onTrackStarted = this;
    loadData();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      if ('${event[1]}' == '1') {
        print('SHORT STATUS EVENT: $event');
        final state = generateState(event);
        addCurrentModel(state.model);
        addEvent(state);
        _uploadTimer++;
        if (_uploadTimer == 30) {
          _uploadTimer = 0;
          saveLogs();
        }
      }
    });
  }

  @override
  ShortStatus generateModel(String rawData) {
    final splitObject = rawData.split(' ');
    var voltage = double.parse(splitObject[1]);
    final currentCharge = double.parse(splitObject[2]);
    final currentDischarge = double.parse(splitObject[3]);
    var current = currentCharge != 0 ? currentCharge : -currentDischarge;
    final temperature = tempConverter.tempFromADC(int.parse(splitObject[4]));
    current /= 100;
    voltage /= 100;
    if (_shouldCollectWatts == true) {
      final watt = (current * voltage).abs();
      print('watt: ${watt}');
      _collectedWatts.add(watt);
    }
    return ShortStatusModel(
        totalVoltage: voltage,
        current: current <= 0.02 && current >= -0.02 ? 0.0 : current,
        temperature: temperature);
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Short Status Bloc');
    super.dispose();
  }

  @override
  void onTrackStarted() {
    _shouldCollectWatts = true;
    _wattCollectionTimer = Timer.periodic(Duration(minutes: 1), (_) {
      _wattCollector.watts +=
          (_collectedWatts.reduce((a, b) => a + b) / _collectedWatts.length);
    });
  }

  @override
  void onTrackFinished(double hours) {
    _shouldCollectWatts = false;
    final wattsPerHour = _wattCollector.watts / hours;
    _wattCollector.onWattHoursCalculated.onWattHoursCalculated(wattsPerHour);
    _collectedWatts.clear();
    _wattCollector.watts = 0;
    _wattCollectionTimer.cancel();
  }
}

import 'package:ble_app/src/blocs/MotoHoursTracker.dart';
import 'package:ble_app/src/blocs/base/StateBloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/mixins/DeltaHolder.dart';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusModel.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';

@injectable
class FullStatusBloc extends StateBloc<FullStatus, FullLogModel>
    with DeltaCalculation {
  final DeviceRepository _repository;

  final MotoHoursTracker _motoHoursTracker;

  final tempConverter = TemperatureConverter();

  int _uploadTimer = 0;

  FullStatusBloc(this._repository, this._motoHoursTracker) : super();

  @override
  create() {
    logger.wtf('CREATING IN FULL STATUS BLOC');
    loadData();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      if ('${event[1]}' == '2' &&
          '${event[0]}' != 'R' &&
          !event.contains('OK')) {
        print('FULL STATUS EVENT: $event');
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

  void initMotoTimers() => _motoHoursTracker.init();

  void pauseMotoTimers() => _motoHoursTracker.cancelTimer();

  @override
  pause() {
    logger.wtf('PAUSING IN FULL STATUS BLOC');
    super.pause();
  }

  @override
  resume() {
    super.resume();
    logger.wtf('RESUMING IN FULL STATUS BLOC');
    _repository.resumeTimer(false); // change this boolean please
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Full Status Bloc');
    _motoHoursTracker.dispose();
    super.dispose();
  }

  @override
  FullStatus generateModel(String rawData) {
    final fullStatus = <FullStatusDataModel>[];

    int counter = 0;

    double voltage = 0;
    double current;

    int temperature;

    final List<String> splitObject = rawData.split('  ');
    for (int i = splitObject.length - 1; i >= 0; i--) {
      List<String> splitInner = splitObject[i].split(' ');
      for (int j = 0; j < splitInner.length; j++) {
        if (i != splitObject.length - 1) {
          if (splitInner[j] != '' && splitInner[j].length != 2) {
            counter++;
            final cellVoltage = double.parse(splitInner[j]);
            voltage += cellVoltage;
            fullStatus.add(FullStatusDataModel(
                x: counter,
                y: cellVoltage,
                color: (cellVoltage / 100) > currentParams.balanceCellVoltage
                    ? Colors.redAccent
                    : Colors.lightBlueAccent));
          }
        } else {
          current = splitInner[1] != '0'
              ? double.parse(splitInner[1])
              : (double.parse(splitInner[2]) * -1);
          temperature = tempConverter.tempFromADC(int.parse(splitInner[3]));
        }
      }
    }

    if (!fullStatus.isEmpty) {
      final maxValue = fullStatus
          .reduce((value, element) => value.y > element.y ? value : element);

      final lowestValue = fullStatus
          .reduce((value, element) => value.y < element.y ? value : element);

      deltaCounter++;

      current = current / 100;

      final diff = maxValue.y - lowestValue.y;
      tempDelta += diff;

      final maxDeltaThreshold =
          getParameters().value.maxTimeLimitedDischargeCurrent / 2;

      if (-current > maxDeltaThreshold) {
        if (lastDelta > maxDelta) {
          maxDelta = lastDelta;
          deltaMaxHolder.addEvent(maxDelta);
        }
      }

      if (deltaCounter == 4) {
        final deltaEvent = tempDelta / 4;
        lastDelta = deltaEvent;
        deltaHolder.addEvent(deltaEvent);
        tempDelta = 0;
        deltaCounter = 0;
      }
    }

    return FullStatus(
        fullStatus: fullStatus,
        totalVoltage: voltage / 100,
        current: current <= 0.02 && current >= -0.02 ? 0.0 : current,
        temperature: temperature,
        delta: (lastDelta / 100));
  }
}

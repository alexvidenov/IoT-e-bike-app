import 'package:ble_app/src/blocs/StateBloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/blocs/mixins/DeltaHolder.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusModel.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';

@injectable
class FullStatusBloc extends StateBloc<FullStatus> with DeltaCalculation {
  final DeviceRepository _repository;

  final tempConverter = TemperatureConverter();

  int _uploadTimer = 0;

  FullStatusBloc(this._repository) : super();

  @override
  create() {
    loadData();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      //final _model = _generateFullStatus(e);
      addEvent(generateState(event));
      _uploadTimer++;
      if (_uploadTimer == 10) {
        _uploadTimer = 0;
        //addData(_model);
      }
    });
  }

  @override
  pause() {
    _repository.cancel();
    super.pause();
  }

  @override
  resume() {
    _repository.resumeTimer(false); // change this boolean please
    super.resume();
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Full Status Bloc');
    super.dispose();
  }

  @override
  FullStatus generateModel(String rawData) {
    final fullStatus = <FullStatusDataModel>[];

    int counter = 0;

    double voltage = 0;
    double current;

    int temperature;

    deltaCounter++;

    List<String> splitObject = rawData.split('  ');
    for (int i = splitObject.length - 1; i >= 0; i--) {
      List<String> splitInner = splitObject[i].split(' ');
      for (int j = 0; j < splitInner.length; j++) {
        if (i != splitObject.length - 1) {
          if (splitInner[j] != '' && splitInner[j].length != 2) {
            counter++;
            voltage += double.parse(splitInner[j]);
            fullStatus.add(FullStatusDataModel(
                x: counter,
                y: double.parse(splitInner[j]),
                color: Colors.lightBlueAccent));
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

      final diff = maxValue.y - lowestValue.y;
      current = current / 100;
      final threshold = getParameters().value.motoHoursCounterCurrentThreshold;
      if (current < threshold) {
        delta1 += diff;
        if (deltaCounter == 4) {
          delta1Holder.addEvent(delta1 / 4);
          delta1 = 0;
          deltaCounter = 0;
        }
      } else if (current >
          (getParameters().value.maxTimeLimitedDischargeCurrent / 2)) {
        delta2 += diff;
        if (deltaCounter == 4) {
          delta2Holder.addEvent(delta2 / 4);
          delta2 = 0;
          deltaCounter = 0;
        }
      }
    }

    return FullStatus(
        fullStatus: fullStatus,
        totalVoltage: voltage / 100,
        current: current,
        temperature: temperature);
  }
}

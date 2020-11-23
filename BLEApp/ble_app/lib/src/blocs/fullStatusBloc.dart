import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/fullStatusBarGraphModel.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/utils/Converter.dart';

class FullStatusBloc extends Bloc<List<FullStatusDataModel>, String> {
  final DeviceRepository _repository;

  FullStatusBloc(this._repository) : super();

  _listenToFullStatus() {
    streamSubscription = _repository.characteristicValueStream.listen(
        (event) => // if(event.lenght > someArbitrary shit)
            addEvent(_generateFullStatusDataModel(
                Converter.generateFullStatus(event))));
  }

  init() => _listenToFullStatus();

  dynamic pause() {
    _repository.cancel();
    pauseSubscription();
  }

  dynamic resume() {
    _repository.resumeTimer(false); // change this boolean please
    resumeSubscription();
  }

  List<FullStatusDataModel> _generateFullStatusDataModel(
      List<double> voltages) {
    List<FullStatusDataModel> fullStatus = <FullStatusDataModel>[];
    for (int i = 0; i < 20; i++) {
      // this 20 is not hardcoded 20, you know, should get shred prefs cel count here.
      var color = voltages.elementAt(i) > 40
          ? Colors.redAccent
          : Colors.lightBlueAccent;
      fullStatus.add(FullStatusDataModel(i + 1, voltages.elementAt(i), color));
    }
    return fullStatus;
  }
}

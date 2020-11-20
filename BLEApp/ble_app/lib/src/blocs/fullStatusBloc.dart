import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/modules/fullStatusBarGraphModel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ble_app/src/utils.dart';

class FullStatusBloc extends Bloc<List<FullStatusDataModel>, String> {
  final repository = GetIt.I<BluetoothRepository>();

  FullStatusBloc();

  List<FullStatusDataModel> _generateFullStatusDataModel(
      List<double> voltages) {
    List<FullStatusDataModel> fullStatus = <FullStatusDataModel>[];
    for (int i = 0; i < 20; i++) {
      // this 20 is not hardcoded 20, you know
      var color = voltages.elementAt(i) > 30
          ? Colors.redAccent
          : Colors.lightBlueAccent;
      fullStatus.add(FullStatusDataModel(i + 1, voltages.elementAt(i), color));
    }
    return fullStatus;
  }

  _listenToFullStatus() {
    streamSubscription = repository.characteristicValueStream.listen(
        (event) => // if(event.lenght > someArbitrary shit)
            addEvent(_generateFullStatusDataModel(
                Converter.generateFullStatus(event))));
  }

  startGeneratingFullStatus() {
    repository.periodicFullStatus();
    _listenToFullStatus();
  }

  dynamic cancel() {
    repository.cancelTimer();
    pauseSubscription();
  }

  dynamic resume() {
    repository.resumeTimer(false); // change this boolean please
    resumeSubscription();
  }
}

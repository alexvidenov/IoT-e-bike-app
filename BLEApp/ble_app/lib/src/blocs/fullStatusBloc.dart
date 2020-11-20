import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/modules/fullStatusBarGraphModel.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ble_app/src/utils.dart';

class FullStatusBloc extends Bloc<FullStatusDataModel, String> {
  FullStatusBloc() {
    streamSubscription = GetIt.I<BluetoothRepository>()
        .characteristicValueStream
        .listen((event) => addEvent(
            _generateFullStatusDataModel(Converter.generateFullStatus(event))));
  }

  _generateFullStatusDataModel(List<double> voltages) {
    List<FullStatusDataModel> fullStatus;
    for (int i = 0; i < 20; i++) {
      var color = voltages[i] > 30 ? Colors.red : Colors.blue;
      fullStatus[i] = FullStatusDataModel(i + 1, voltages.elementAt(i), color);
    }
  }
}

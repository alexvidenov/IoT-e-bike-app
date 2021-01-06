import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusBarGraphModel.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class FullStatusBloc extends Bloc<List<FullStatusDataModel>, String> {
  final DeviceRepository _repository;

  FullStatusBloc(this._repository) : super();

  @override
  void create() => _listenToFullStatus();

  @override
  pause() {
    _repository.cancel();
    pauseSubscription();
  }

  @override
  resume() {
    _repository.resumeTimer(false); // change this boolean please
    resumeSubscription();
  }

  _listenToFullStatus() {
    streamSubscription = _repository.characteristicValueStream
        .listen((event) => // if(event.length > someArbitrary shit)
            addEvent(_generateFullStatusDataModel(_generateFullStatus(event))));
  }
}

extension FullStatusParse on FullStatusBloc {
  List<FullStatusDataModel> _generateFullStatusDataModel(
      List<double> voltages) {
    List<FullStatusDataModel> fullStatus = <FullStatusDataModel>[];
    for (int i = 0; i < 20; i++) {
      // this 20 is not hardcoded 20, you know, should get shred prefs cel count here.
      var color = voltages.elementAt(i) > 40
          ? Colors.redAccent
          : Colors.lightBlueAccent;
      fullStatus.add(FullStatusDataModel(
          x: i + 1, y: voltages.elementAt(i), color: color));
    }
    return fullStatus;
  }

  List<double> _generateFullStatus(String rawData) {
    List<String> splittedObjects = rawData.split(' ');

    List<double> cellVoltages = List(20);

    for (int i = 0; i < 20; i++) {
      cellVoltages[i] = double.parse(splittedObjects.elementAt(i));
    }

    return cellVoltages;
  }
}

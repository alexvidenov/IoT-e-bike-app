import 'dart:convert';

import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';

import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/services/Auth.dart';
import 'package:ble_app/src/services/Storage.dart';

class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  final DeviceRepository _repository;

  int _uploadTimer = 0;

  Map<String, Map<String, double>> _data;

  ShortStatusBloc(this._repository) : super();

  @override
  pause() {
    _repository.cancel();
    pauseSubscription();
    Storage(uid: locator<Auth>().getCurrentUserId()).upload(_data); // initial test implementation
  }

  @override
  resume() {
    _repository.resumeTimer(true);
    resumeSubscription();
  }

  @override
  void create() {
    //_initData();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      ShortStatusModel _model = _generateShortStatus(event);
      addEvent(_model);
      _uploadTimer++;
      //var json = { // an example json form 
      //'date_time': {
      //  'voltage': _model.getTotalVoltage,
      // 'temp': _model.getTemperature,
      //  },
      // };
      if (_uploadTimer == 10) {
        _data[DateTime.now().toString()] = {
          'voltage': _model.getTotalVoltage,
          'currentCharge': _model.getCurrentCharge,
          'currentDisCharge': _model.getCurrentDischarge,
          'temperature': _model.getTemperature,
        };
        _uploadTimer = 0;
        // locator<SettingsBloc>().setUserData(jsonEncode(_data));
      }
    });
  }

   // for future use
  _initData() {
    String data = locator<SettingsBloc>().getUserData();
    if (data != 'empty') {
      _data = jsonDecode(data);
    } else {
      _data = Map();
    }
  }

  ShortStatusModel _generateShortStatus(String rawData) {
    List<String> splittedObject = rawData.split(' ');
    var voltage = double.parse(splittedObject.elementAt(0));
    var currentCharge = double.parse(splittedObject.elementAt(1));
    var currentDischarge = double.parse(splittedObject.elementAt(2));
    var temperature = double.parse(splittedObject.elementAt(3));
    ShortStatusModel shortStatusViewModel = ShortStatusModel();
    shortStatusViewModel.setParameters(
        voltage, currentCharge, currentDischarge, temperature);
    return shortStatusViewModel;
  }
}

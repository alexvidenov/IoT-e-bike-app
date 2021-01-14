import 'dart:async';
import 'dart:collection';

import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterHolder.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:ble_app/src/sealedStates/ParameterFetchState.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

@injectable
class DeviceParametersBloc extends Bloc<ParameterFetchState, String> {
  final DeviceRepository _repository;
  final ParameterHolder _parameterHolder;

  DeviceParametersBloc(this._repository, this._parameterHolder) : super();

  var _parameters = SplayTreeMap<String, double>();

  @override
  create() {
    super.create();
    addEvent(ParameterFetchState.fetching());
    queryParameters();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      print('PARAMETER EVENT: ' + event);
      var buffer = StringBuffer();
      for (var i = 3; i < event.length; i++) {
        buffer.write('${event[i]}');
      }
      final value = double.parse(buffer.toString());
      print('Parameter: ' + value.toString());
      switch ('${event[1]}' + '${event[2]}') {
        // R010428 -> we get 01
        case '00':
          _parameters['0'] = value;
          break;
        case '01':
          _parameters['1'] = value;
          break;
        case '02':
          _parameters['2'] = value;
          break;
        case '26':
          _parameters['26'] = value;
          //_parameterHolder.deviceParameters = _parameters;
          ParameterFetchState.fetched(
              parameters: DeviceParametersModel(
                  cellCount: _parameters['0']
                      .toInt())); // TODO fill in the rest of the params
          break;
      }
    });
  }

  @override
  pause() => pauseSubscription();

  @override
  resume() => resumeSubscription();

  queryParameters() {
    // Clear this up somehow
    Future.delayed(Duration(milliseconds: 80), () {
      _repository.writeToCharacteristic('R00\r');
    }).then((_) => Future.delayed(Duration(milliseconds: 80), () {
          _repository.writeToCharacteristic('R01\r');
        })
            .then((_) => Future.delayed(Duration(milliseconds: 80), () {
                  _repository.writeToCharacteristic('R02\r');
                }))
            .then((_) => Future.delayed(Duration(milliseconds: 80), () {
                  _repository.writeToCharacteristic('R26\r');
                })));
  }

  @override
  mapEventToState(data, EventSink<ParameterFetchState> sink) {

  }
}

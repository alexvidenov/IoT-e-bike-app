import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';

import 'package:ble_app/src/modules/shortStatusModel.dart';

class ShortStatusBloc extends Bloc<ShortStatusModel, String> {
  final DeviceRepository _repository;

  ShortStatusBloc(this._repository) : super();

  @override
  pause() {
    _repository.cancel();
    pauseSubscription();
  }

  @override
  resume() {
    _repository.resumeTimer(true);
    resumeSubscription();
  }

  @override
  void create() => streamSubscription = _repository.characteristicValueStream
      .listen((event) => addEvent(_generateShortStatus(event)));

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

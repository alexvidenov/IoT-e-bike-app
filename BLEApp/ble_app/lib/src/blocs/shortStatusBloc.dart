import 'package:ble_app/main.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';

import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:ble_app/src/utils/ADCToTemp.dart';
import 'package:injectable/injectable.dart';

import 'StateBloc.dart';

@injectable
class ShortStatusBloc extends StateBloc<ShortStatus> {
  final DeviceRepository _repository;

  final tempConverter = TemperatureConverter();

  int _uploadTimer = 0;

  ShortStatusBloc(this._repository) : super();

  @override
  pause() {
    super.pause();
    _repository.cancel();
  }

  @override
  resume() {
    super.resume();
    _repository.resumeTimer(true);
  }

  @override
  create() {
    loadData();
    streamSubscription = _repository.characteristicValueStream.listen((event) {
      logger.wtf('SHORT STATUS EVENT: $event');
      addEvent(generateState(event));
      _uploadTimer++;
      if (_uploadTimer == 10) {
        _uploadTimer = 0;
        addData<ShortStatus>(generateModel(event));
      }
    });
  }

  @override
  ShortStatus generateModel(String rawData) {
    final splitObject = rawData.split(' ');
    final voltage = double.parse(splitObject[1]);
    final currentCharge = double.parse(splitObject[2]);
    final currentDischarge = double.parse(splitObject[3]);
    final current = currentCharge != 0 ? currentCharge : -currentDischarge;
    final temperature = tempConverter.tempFromADC(int.parse(splitObject[4]));
    return ShortStatusModel(
        totalVoltage: voltage / 100,
        current: current / 100,
        temperature: temperature);
  }

  @override
  dispose() {
    logger.wtf('Closing stream in Short Status Bloc');
    super.dispose();
  }
}

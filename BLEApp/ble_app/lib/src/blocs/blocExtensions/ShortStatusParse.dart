part of '../shortStatusBloc.dart';

extension ShortStatusParse on ShortStatusBloc {
  ShortStatusState _generateShortStatus(String rawData) {
    final splitObject = rawData.split(' ');
    final voltage = double.parse(splitObject[1]);
    final currentCharge = double.parse(splitObject[2]);
    final currentDischarge = double.parse(splitObject[3]);
    final current = currentCharge != 0 ? currentCharge : -currentDischarge;
    final temperature = tempConverter.tempFromADC(int.parse(splitObject[4]));
    final model = ShortStatusModel(
        totalVoltage: voltage / 100,
        current: current / 100,
        temperature: temperature);
    if (current < 0 &&
        current > getParameters().value.maxTimeLimitedDischargeCurrent) {
      // stuff
    }
    if (temperature > getParameters().value.maxTemperatureRecovery) {
      return ShortStatusState.error(ShortStatusErrorState.HighTemp, model);
    } else if (temperature < getParameters().value.minCutoffTemperature) {
      return ShortStatusState.error(ShortStatusErrorState.LowTemp, model);
    }
    return ShortStatusState(model);
  }
}

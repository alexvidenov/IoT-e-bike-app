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
        totalVoltage: voltage, current: current, temperature: temperature);
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

/*
  ShortStatusModel _generateShortStatus(String rawData) {
    final List<String> splitObject = rawData.split(' ');
    final currentCharge = double.parse(splitObject[2]);
    final currentDischarge = double.parse(splitObject[3]);
    final current = currentCharge != 0 ? currentCharge : -currentDischarge;
    return ShortStatusModel(
        totalVoltage: double.parse(splitObject[1]),
        current: current,
        temperature: tempConverter.tempFromADC(int.parse(splitObject[4])));
  }

  ShortStatusState _generateState(ShortStatusModel model) {
    final abnormalities = <ShortStatusErrorState>[];
    final endTemp = tempConverter.tempFromADC(getParameters()
        .value
        .maxTemperatureRecovery);
    if (model.current < 0 &&
        model.current >
            getParameters().value.maxTimeLimitedDischargeCurrent)
      abnormalities
          .add(ShortStatusErrorState.OverDischarge);
    else if (model.current > 0 &&
        model.current <
            getParameters().value.maxCutoffChargeCurrent) abnormalities
        .add(ShortStatusErrorState.Overcharge);
    else if(model.temperature)
  }
   */
}

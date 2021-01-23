part of '../shortStatusBloc.dart';

extension ShortStatusParse on ShortStatusBloc {
  ShortStatusModel _generateShortStatus(String rawData) {
    List<String> splitObject = rawData.split(' ');
    final voltage = double.parse(splitObject[1]);
    final currentCharge = double.parse(splitObject[2]);
    final currentDischarge = double.parse(splitObject[3]);
    final current = currentCharge != 0 ? currentCharge : currentDischarge;
    final temperature = tempConverter.tempFromADC(int.parse(splitObject[4]));
    return ShortStatusModel(
        totalVoltage: voltage, current: current, temperature: temperature);
  }
}

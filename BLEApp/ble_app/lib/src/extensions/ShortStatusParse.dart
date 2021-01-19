part of '../blocs/shortStatusBloc.dart';

extension ShortStatusParse on ShortStatusBloc {
  ShortStatusModel _generateShortStatus(String rawData) {
    List<String> splitObject = rawData.split(' ');
    final voltage = double.parse(splitObject[1]);
    final currentCharge = double.parse(splitObject[2]);
    final currentDischarge = double.parse(splitObject[3]);
    final temperature = double.parse(splitObject[4]);
    return ShortStatusModel(
        totalVoltage: voltage,
        currentCharge: currentCharge,
        currentDischarge: currentDischarge,
        temperature: temperature);
  }
}

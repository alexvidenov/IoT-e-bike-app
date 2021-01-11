part of '../blocs/shortStatusBloc.dart';

extension ShortStatusParse on ShortStatusBloc {
  ShortStatusModel _generateShortStatus(String rawData) {
    List<String> splitObject = rawData.split(' ');
    final voltage = double.parse(splitObject.elementAt(0));
    final currentCharge = double.parse(splitObject.elementAt(1));
    final currentDischarge = double.parse(splitObject.elementAt(2));
    final temperature = double.parse(splitObject.elementAt(3));
    return ShortStatusModel(
        totalVoltage: voltage,
        currentCharge: currentCharge,
        currentDischarge: currentDischarge,
        temperature: temperature);
  }
}

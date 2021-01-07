part of '../blocs/shortStatusBloc.dart';

extension ShortStatusParse on ShortStatusBloc {
  ShortStatusModel _generateShortStatus(String rawData) {
    List<String> splittedObject = rawData.split(' ');
    final voltage = double.parse(splittedObject.elementAt(0));
    final currentCharge = double.parse(splittedObject.elementAt(1));
    final currentDischarge = double.parse(splittedObject.elementAt(2));
    final temperature = double.parse(splittedObject.elementAt(3));
    return ShortStatusModel(
        totalVoltage: voltage,
        currentCharge: currentCharge,
        currentDischarge: currentDischarge,
        temperature: temperature);
  }
}

part of '../shortStatusBloc.dart';

extension ShortStatusParse on ShortStatusBloc {
  ShortStatusModel _generateShortStatus(String rawData) {
    List<String> splitObject = rawData.split(' ');
    final voltage = double.parse(splitObject[1]);
    final currentCharge = double.parse(splitObject[2]);
    final currentDischarge = double.parse(splitObject[3]);
    double current;
    if (currentCharge != 0) {
      current = currentCharge;
    } else {
      current = -currentDischarge;
    }
    final temperature = double.parse(splitObject[4]);
    return ShortStatusModel(voltage, current, temperature);
  }
}

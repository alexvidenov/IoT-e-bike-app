part of '../shortStatusBloc.dart';

extension ShortStatusParse on ShortStatusBloc {
  ShortStatusModel _generateShortStatus(String rawData) {
    List<String> splitObject = rawData.split(' ');
    final voltage = double.parse(splitObject[1]);
    final currentCharge = double.parse(splitObject[2]);
    final currentDischarge = double.parse(splitObject[3]);
    if (currentCharge != 0) {
      String thingToEmit =
          '+$currentCharge'; // this will be the param in the shortStatusModel
    } else {
      String thingToEmit = '-$currentDischarge';
    }
    final temperature = double.parse(splitObject[4]);
    // TODO check which is 0 (of the currents) and emit string with + or - with the value. UI won't execute any business logic
    return ShortStatusModel(
        voltage, currentCharge, currentDischarge, temperature);
  }
}

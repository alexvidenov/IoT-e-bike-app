part of '../blocs/fullStatusBloc.dart';

extension FullStatusParse on FullStatusBloc {
  List<FullStatusDataModel> _generateFullStatus(String rawData) {
    final fullStatus = <FullStatusDataModel>[];

    int elementCounter = 0;

    List<String> splitObject = rawData.split('  '); // gets packets of 4

    for (var i = splitObject.length - 2; i >= 1; i--) {
      List<String> splitInner =
          splitObject[i].split(' '); // gets inner value of every packet
      for (var j = 0; j < splitInner.length; j++) {
        elementCounter++;
        final value = double.parse(splitInner[j]);
        fullStatus.add(FullStatusDataModel(
            x: elementCounter,
            y: value,
            color: value > 40 // > FIXME USE VBAL_CONST here
                ? Colors.redAccent
                : Colors.lightBlueAccent));
      }
    }
    return fullStatus;
  }
}

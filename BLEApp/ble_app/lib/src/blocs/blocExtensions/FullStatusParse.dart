part of '../fullStatusBloc.dart';

extension FullStatusParse on FullStatusBloc {
  FullStatusModel _generateFullStatus(String rawData) {
    final fullStatus = <FullStatusDataModel>[];

    int counter = 0;

    double current;
    double temperature;
    BattStatus battStatus;
    double totalVoltage = 0;

    String status = '${rawData[0]}';

    switch (status) {
      case '0':
        battStatus = BattStatus.OK;
        break;
      case '4':
        battStatus = BattStatus.OD;
        break;
      case 'A':
        battStatus = BattStatus.OC;
        break;
      case 'E':
        battStatus = BattStatus.OCOD;
        break;
      case '2':
        battStatus = BattStatus.SC;
        break;
    }

    List<String> splitObject = rawData.split('  ');

    for (int i = splitObject.length - 1; i >= 0; i--) {
      List<String> splitInner = splitObject[i].split(' ');
      for (int j = 0; j < splitInner.length; j++) {
        if (i != splitObject.length - 1) {
          if (splitInner[j] != '' && splitInner[j].length != 2) {
            counter++;
            totalVoltage += double.parse(splitInner[j]);
            fullStatus.add(FullStatusDataModel(
                x: counter,
                y: double.parse(splitInner[j]),
                color: Colors.lightBlueAccent));
          }
        } else {
          current = splitInner[1] != '0'
              ? double.parse(splitInner[1])
              : double.parse(splitInner[2]);
          temperature = double.parse(splitInner[3]);
        }
      }
    }
    return FullStatusModel(
        fullStatus, totalVoltage, current, temperature, 0, 0, 0, battStatus);
  }
}

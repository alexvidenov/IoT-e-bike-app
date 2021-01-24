part of '../fullStatusBloc.dart';

extension FullStatusParse on FullStatusBloc {
  FullStatusModel _generateFullStatus(String rawData) {
    final fullStatus = <FullStatusDataModel>[];

    int counter = 0;

    double totalVoltage = 0;
    double current;

    int temperature;

    BattStatus battStatus;

    deltaCounter++;

    final String status = '${rawData[0]}';

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
      case 'C': // should be E, regarding the new protocol?
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
              : (double.parse(splitInner[2]) * -1);
          temperature = tempConverter.tempFromADC(int.parse(splitInner[3]));
        }
      }
    }

    if (!fullStatus.isEmpty) {
      final maxValue = fullStatus
          .reduce((value, element) => value.y > element.y ? value : element);

      final lowestValue = fullStatus
          .reduce((value, element) => value.y < element.y ? value : element);

      final diff = maxValue.y - lowestValue.y;

      if (current < getParameters().value.motoHoursCounterCurrentThreshold) {
        delta1 += diff;
        if (deltaCounter == 4) {
          delta1Holder
              .addEvent(delta1 / 4); // TODO: check if / 100 is not needed
          delta1 = 0;
          deltaCounter = 0;
        }
      } else if (current >
          (getParameters().value.maxTimeLimitedDischargeCurrent / 2)) {
        delta2 += diff;
        if (deltaCounter == 4) {
          delta2Holder.addEvent(delta2 / 4);
          delta2 = 0;
          deltaCounter = 0;
        }
      }
    }

    return FullStatusModel(
        fullStatus, totalVoltage / 100, current / 100, temperature, 0, battStatus);
  }
}

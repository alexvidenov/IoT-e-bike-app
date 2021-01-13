part of '../blocs/fullStatusBloc.dart';

extension FullStatusParse on FullStatusBloc {
  List<FullStatusDataModel> _generateFullStatusDataModel(
      List<double> voltages) {
    final fullStatus = <FullStatusDataModel>[];
    for (int i = 0; i < voltages.length; i++) {
      // this 20 is not hardcoded 20, you know, should get shared prefs cel count here.
      final color = voltages.elementAt(i) > 40 // > FIXME VBAL_CONST
          ? Colors.redAccent
          : Colors.lightBlueAccent;
      fullStatus.add(FullStatusDataModel(
          x: i + 1, y: voltages.elementAt(i), color: color));
    }
    return fullStatus;
  }

  List<double> _generateFullStatus(String rawData) {
    List<String> splitObject = rawData.split(' ');

    List<double> cellVoltages = [];

    for (int i = 0; i < splitObject.length; i++) {
      cellVoltages.insert(i, double.parse(splitObject.elementAt(i)));
    }

    return cellVoltages;
  }

  List<FullStatusDataModel> generateFullStatus(String rawData) {
    final fullStatus = <FullStatusDataModel>[];

    int elementCounter = 0;

    List<String> splitObject = rawData.split('  '); // gets packets of 4

    for (var i = splitObject.length - 2; i >= 1; i--) {
      List<String> splitInner = splitObject[i].split(' '); // gets inner value of every packet
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

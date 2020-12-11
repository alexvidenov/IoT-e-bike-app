part of bloc;

extension FullStatusParse on FullStatusBloc {
  List<FullStatusDataModel> _generateFullStatusDataModel(
      List<double> voltages) {
    List<FullStatusDataModel> fullStatus = <FullStatusDataModel>[];
    for (int i = 0; i < 20; i++) {
      // this 20 is not hardcoded 20, you know, should get shared prefs cel count here.
      final color = voltages.elementAt(i) > 40
          ? Colors.redAccent
          : Colors.lightBlueAccent;
      fullStatus.add(FullStatusDataModel(
          x: i + 1, y: voltages.elementAt(i), color: color));
    }
    return fullStatus;
  }

  List<double> _generateFullStatus(String rawData) {
    List<String> splittedObjects = rawData.split(' ');

    List<double> cellVoltages = List(20);

    for (int i = 0; i < 20; i++) {
      cellVoltages[i] = double.parse(splittedObjects.elementAt(i));
    }

    return cellVoltages;
  }
}

import 'package:ble_app/src/modules/shortStatusModel.dart';

class Converter {
  static ShortStatusModel generateShortStatus(String rawData) {
    List<String> splittedObject = rawData.split(' ');
    var voltage = double.parse(splittedObject.elementAt(0));
    var currentCharge = double.parse(splittedObject.elementAt(1));
    var currentDischarge = double.parse(splittedObject.elementAt(2));
    var temperature = double.parse(splittedObject.elementAt(3));
    ShortStatusModel shortStatusViewModel = ShortStatusModel();
    shortStatusViewModel.setParameters(
        voltage, currentCharge, currentDischarge, temperature);
    return shortStatusViewModel;
  }

  static List<double> generateFullStatus(String rawData) {
    List<String> splittedObjects = rawData.split(' ');

    List<double> cellVoltages = List(20);

    for (int i = 0; i < 20; i++) {
      cellVoltages[i] = double.parse(splittedObjects.elementAt(i));
    }

    return cellVoltages;
  }
}

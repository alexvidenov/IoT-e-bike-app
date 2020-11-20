import 'package:flutter/material.dart';
import 'modules/shortStatusModel.dart';

Color firstColor = Color(0xFF7A36DC);
Color secondColor = Color(0xFF7A36DC).withOpacity(0.5);
Color thirdColor = Color(0xFF7A36DC).withOpacity(0.2);

Color greyColor = Color(0xFFE6E6E6);
Color darkGreyColor = Color(0xFFB8B2CB);

final appTheme = ThemeData(
  primarySwatch: Colors.blue,
);

String percentageModifier(double value) {
  final roundedValue = value.ceil().toInt().toString();
  return '$roundedValue km/h';
}

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class AppTheme {}

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

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

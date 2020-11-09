import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

final customWidth01 =
    CustomSliderWidths(trackWidth: 2, progressBarWidth: 20, shadowWidth: 50);

final customColors01 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: HexColor('#FF8282').withOpacity(0.6),
    progressBarColors: [
      HexColor('#FFE2E2').withOpacity(0.9),
      HexColor('#FFAD8D').withOpacity(0.9),
      HexColor('#FE6490').withOpacity(0.5)
    ],
    shadowColor: HexColor('#FFD7E2'),
    shadowMaxOpacity: 0.08);

final info = InfoProperties(
    mainLabelStyle: TextStyle(
        color: Colors.white, fontSize: 60, fontWeight: FontWeight.w100
    ),
    modifier: percentageModifier
  );

final CircularSliderAppearance appearance01 = CircularSliderAppearance(
    customWidths: customWidth01,
    customColors: customColors01,
    infoProperties: info,
    startAngle: 180,
    angleRange: 180,
    size: 250.0);

String percentageModifier(double value){
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
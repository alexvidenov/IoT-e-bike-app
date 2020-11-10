import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:ble_app/src/utils.dart';

// for speed
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
        color: Colors.black, fontSize: 40, fontWeight: FontWeight.w100),
    modifier: (double value) {
      final temp = value.toInt();
      return '$temp km/h';
    });

final CircularSliderAppearance appearance01 = CircularSliderAppearance(
    customWidths: customWidth01,
    customColors: customColors01,
    infoProperties: info,
    startAngle: 180,
    angleRange: 180,
    size: 250.0);

// for temperature
final customWidth04 =
    CustomSliderWidths(trackWidth: 4, progressBarWidth: 20, shadowWidth: 40);
final customColors04 = CustomSliderColors(
    trackColor: HexColor('#CCFF63'),
    progressBarColor: HexColor('#00FF89'),
    shadowColor: HexColor('#B0FFDA'),
    shadowMaxOpacity: 0.5, //);
    shadowStep: 20);

final info04 = InfoProperties(
    bottomLabelStyle: TextStyle(
        color: HexColor('#6DA100'), fontSize: 20, fontWeight: FontWeight.w600),
    bottomLabelText: 'Temp.',
    mainLabelStyle: TextStyle(
        color: HexColor('#54826D'),
        fontSize: 30.0,
        fontWeight: FontWeight.w600),
    modifier: (double value) {
      final temp = value.toInt();
      return '$temp ˚C';
    });

final CircularSliderAppearance appearance04 = CircularSliderAppearance(
    customWidths: customWidth04,
    customColors: customColors04,
    infoProperties: info04,
    startAngle: 90,
    angleRange: 90,
    size: 200.0,
    animationEnabled: true);

// for voltage
final customWidth09 =
    CustomSliderWidths(trackWidth: 1, progressBarWidth: 15, shadowWidth: 50);
final customColors09 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.5),
    trackColor: HexColor('#000000').withOpacity(0.1),
    progressBarColors: [
      HexColor('#3586FC').withOpacity(0.1),
      HexColor('#FF8876').withOpacity(0.25),
      HexColor('#3586FC').withOpacity(0.5)
    ],
    shadowColor: HexColor('#133657'),
    shadowMaxOpacity: 0.02);

final infoProperties09 = InfoProperties(
    bottomLabelStyle: TextStyle(
        color: HexColor('#6DA100'), fontSize: 20, fontWeight: FontWeight.w600),
    bottomLabelText: 'Volt.',
    mainLabelStyle: TextStyle(
        color: HexColor('#54826D'),
        fontSize: 30.0,
        fontWeight: FontWeight.w600),
    modifier: (double value) {
      final temp = value.toInt();
      return '$temp V';
    });

final CircularSliderAppearance appearance09 = CircularSliderAppearance(
    customWidths: customWidth09,
    customColors: customColors09,
    infoProperties: infoProperties09,
    startAngle: 55,
    angleRange: 110,
    size: 230.0,
    animationEnabled: true,
    counterClockwise: true);

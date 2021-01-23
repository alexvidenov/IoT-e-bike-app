//import 'package:kdtree/kdtree.dart';

import 'package:kdtree/kdtree.dart';

class TemperatureConverter {
  KDTree kdTree;
  KDTree kdTree2;

  final tempScale = 5;

  final distance = (dynamic value1, dynamic value2) =>
      ((value1['adcValue'] - value2['adcValue']) as int).abs();

  final distance2 = (dynamic value1, dynamic value2) =>
      ((value1['tempInC'] - value2['tempInC']) as int).abs();

  final values = [
    {'adcValue': 2965, 'tempInC': -5},
    {'adcValue': 2455, 'tempInC': 0},
    {'adcValue': 2021, 'tempInC': 5},
    {'adcValue': 1657, 'tempInC': 10},
    {'adcValue': 1356, 'tempInC': 15},
    {'adcValue': 1110, 'tempInC': 20},
    {'adcValue': 909, 'tempInC': 25},
    {'adcValue': 745, 'tempInC': 30},
    {'adcValue': 613, 'tempInC': 35},
    {'adcValue': 506, 'tempInC': 40},
    {'adcValue': 418, 'tempInC': 45},
    {'adcValue': 347, 'tempInC': 50},
    {'adcValue': 290, 'tempInC': 55},
    {'adcValue': 242, 'tempInC': 60},
    {'adcValue': 204, 'tempInC': 65},
  ];

  TemperatureConverter() {
    kdTree = KDTree(values, distance, ['adcValue']);
    kdTree2 = KDTree(values, distance2, ['tempInC']);
  }

  int tempFromADC(int adcValue) {
    final twoNearest = kdTree.nearest({'adcValue': adcValue}, 2); // 909 745
    final nearest = twoNearest.first; // 909
    final secondNearest = twoNearest.elementAt(1);
    //print(nearest);
    final diffCoeff =
        (((nearest[0]['adcValue'] - secondNearest[0]['adcValue']) as int)
                .abs() ~/
            5); // 32.8
    //final diffAdcValue = ((nearest[0]['adcValue'] - adcValue) as int)
    //.abs(); // 59 ACTUALLY HAVE THE DISTANCE
    final divByCoeff = nearest[1] ~/ diffCoeff;
    if (nearest[0]['adcValue'] > adcValue) {
      final returnValue = nearest[0]['tempInC'] + divByCoeff;
      final adcFromTempValue = adcFromTemp(returnValue);
      print('ADC FROM TEMP: $adcFromTempValue');
      return returnValue;
    } else {
      final returnValue = nearest[0]['tempInC'] - divByCoeff;
      final adcFromTempValue = adcFromTemp(returnValue);
      print('ADC FROM TEMP: $adcFromTempValue');
      return returnValue;
    }
  }

  int adcFromTemp(int tempInC) {
    // 37
    final twoNearest = kdTree2.nearest({'tempInC': tempInC}, 2); // 35 40
    final nearest = twoNearest.first; // 35
    final secondNearest = twoNearest.elementAt(1); // 40
    print(nearest);
    final diffCoeff =
        (((nearest[0]['adcValue'] - secondNearest[0]['adcValue']) as int)
                .abs() ~/
            5); // 21.4
    print(diffCoeff);
    if (nearest[0]['tempInC'] > tempInC) {
      return nearest[0]['adcValue'] + (nearest[1] * diffCoeff);
    } else {
      return nearest[0]['adcValue'] - (nearest[1] * diffCoeff);
    }
  }
}

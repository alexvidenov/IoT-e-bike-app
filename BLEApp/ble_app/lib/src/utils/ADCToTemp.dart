class TemperatureConverter {
  final boundaryValues = {
    MapEntry<int, double>(2965, 102): -5,
    MapEntry<int, double>(2455, 86.8): 0,
    MapEntry<int, double>(2021, 72.8): 5,
    MapEntry<int, double>(1657, 60.2): 10,
    MapEntry<int, double>(1356, 49.2): 15,
    MapEntry<int, double>(1110, 40.2): 20,
    MapEntry<int, double>(909, 32.8): 25,
    MapEntry<int, double>(745, 26.4): 30,
    MapEntry<int, double>(613, 21.4): 35,
    MapEntry<int, double>(506, 17.6): 40,
    MapEntry<int, double>(418, 14.2): 45,
    MapEntry<int, double>(347, 11.4): 50,
    MapEntry<int, double>(290, 9.6): 55,
    MapEntry<int, double>(242, 7.6): 60,
    MapEntry<int, double>(204, 6.4): 65
  };

  List<MapEntry<int, double>> get keys => boundaryValues.keys.toList();

  List<int> get adcValues => keys.map((e) => e.key).toList();

  double findCoeffByKey(int value) =>
      keys.firstWhere((e) => e.key == value).value;

  int findTempValue(int value) =>
      boundaryValues.entries.firstWhere((e) => e.key.key == value).value;

  int tempFromADC(int measurement) {
    // 850
    final orderedList = adcValues.where((v) => v >= measurement).toList()
      ..sort();
    final nextGreaterValue = orderedList.first; // 909 in our case
    final diff = nextGreaterValue - measurement; // 59
    final int divByCoeff = diff ~/ findCoeffByKey(nextGreaterValue);
    return findTempValue(nextGreaterValue) + divByCoeff;
  }
}

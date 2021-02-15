import 'dart:convert';

abstract class DataParser {
  static String parseList(List<int> dataFromDevice) =>
      utf8.decode(dataFromDevice);
}

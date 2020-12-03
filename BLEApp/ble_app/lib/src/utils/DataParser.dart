import 'dart:convert';

abstract class DataParser {
  static String parseList(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }
}

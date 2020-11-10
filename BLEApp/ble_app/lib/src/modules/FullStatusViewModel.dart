import 'package:flutter/material.dart';

class FullStatusViewModel with ChangeNotifier{
  List<double> cellVoltages;
  int cells;

  FullStatusViewModel(int cells) {
    this.cells = cells;
    cellVoltages = List();
  }

  set voltages(List<double> cellVoltages){
    this.cellVoltages = cellVoltages;
    notifyListeners();
  }

  List<double> get voltages => this.cellVoltages;
  
}
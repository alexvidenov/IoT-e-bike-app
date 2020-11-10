import 'package:flutter/material.dart';

class ShortStatusViewModel with ChangeNotifier{
  double batteryLevel;

  set battery(double batteryLevel) {
    this.batteryLevel = batteryLevel;
    notifyListeners();
  }

  double get battery => this.batteryLevel;
  
}
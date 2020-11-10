import 'package:flutter/material.dart';

class ShortStatusViewModel with ChangeNotifier {
  double _totalVoltage;
  double _currentCharge;
  double _currentDischarge;
  double _temperature;

  setParameters(double batteryVoltage, double currentCharge,
      double currentDischarge, double temperature) {
    this._totalVoltage = batteryVoltage;
    this._currentCharge = currentCharge;
    this._currentDischarge = currentDischarge;
    this._temperature = temperature;
    notifyListeners();
  }

  double get getTotalVoltage => this._totalVoltage;

  double get getCurrentCharge => this._currentCharge;

  double get getCurrentDischarge => this._currentDischarge;

  double get getTemperature => this._temperature;
}

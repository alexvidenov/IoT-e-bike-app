class ShortStatusModel {
  double _totalVoltage;
  double _currentCharge;
  double _currentDischarge;
  double _temperature;

  ShortStatusModel() {
    this._totalVoltage = 0;
    this._currentCharge = 0;
    this._currentDischarge = 0;
    this._temperature = 0;
  }

  setParameters(double batteryVoltage, double currentCharge,
      double currentDischarge, double temperature) {
    this._totalVoltage = batteryVoltage;
    this._currentCharge = currentCharge;
    this._currentDischarge = currentDischarge;
    this._temperature = temperature;
  }

  double get getTotalVoltage => this._totalVoltage;

  double get getCurrentCharge => this._currentCharge;

  double get getCurrentDischarge => this._currentDischarge;

  double get getTemperature => this._temperature;
}

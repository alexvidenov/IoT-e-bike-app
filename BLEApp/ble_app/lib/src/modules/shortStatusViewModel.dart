class ShortStatusViewModel {
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
  }

  double get getTotalVoltage => this._totalVoltage;

  double get getCurrentCharge => this._currentCharge;

  double get getCurrentDischarge => this._currentDischarge;

  double get getTemperature => this._temperature;

  static ShortStatusViewModel generateObject(String rawData) {
    List<String> splittedObject = rawData.split('  ');
    var voltage = double.parse(splittedObject.elementAt(0));
    var currentCharge = double.parse(splittedObject.elementAt(1));
    var currentDischarge = double.parse(splittedObject.elementAt(2));
    var temperature = double.parse(splittedObject.elementAt(3));
    ShortStatusViewModel shortStatusViewModel = ShortStatusViewModel();
    shortStatusViewModel.setParameters(
        voltage, currentCharge, currentDischarge, temperature);
    return shortStatusViewModel;
  }
}

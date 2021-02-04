enum BatteryState {
  Normal,
  OverDischarge,
  LowVoltage,
  ManualODTriggered,
  OverCharge,
  OverVoltage,
  LowTemp,
  HighTemp,
  CommunicationLoss,
  UltraLowVoltage,
  ShortCircuit,
  Unknown
}

extension BattStatusToString on BatteryState {
  String string() => this.toString().split('.').last;
}

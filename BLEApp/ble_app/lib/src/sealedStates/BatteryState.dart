enum BatteryState {
  Normal,
  Locked,
  OverDischarge,
  OverCurrent,
  MaxPower,
  LowBatt,
  ManualODTriggered,
  OverCharge,
  EndOfCharge,
  LowTemp,
  HighTemp,
  CommunicationLoss, // TODO: alertDialog here
  UltraLowVoltage, // TODO: alertDialog here
  ShortCircuit, // TODO: alertDialog here
  Unknown
}

extension BattStatusToString on BatteryState {
  String string() => this.toString().split('.').last;
}

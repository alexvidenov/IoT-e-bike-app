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
  ErrorCommunication,
  UltraLowVoltage,
  ShortCircuit,
  Unknown
}

extension BattStatusToString on BatteryState {
  String string() => this.toString().split('.').last;
}

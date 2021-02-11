enum BatteryState {
  Normal,
  Locked,
  OverCurrent,
  MaxPower,
  LowBatt,
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

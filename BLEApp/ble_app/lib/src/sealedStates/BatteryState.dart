enum BatteryState {
  Normal,
  OverDischarge,
  UnderVoltageBalance,
  ManualODTriggered,
  OverCharge,
  OverVoltage,
  LowTemp,
  HighTemp,
  CommunicationLoss,
  UnderVoltageCritical,
  ShortCircuit,
  Unknown
}

extension BattStatusToString on BatteryState {
  String string() => this.toString().split('.').last;
}

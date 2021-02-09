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
  Error1, // TODO: alertDialog here. Service -> errors: ulv, comm, short circuit
  Error2, // TODO: alertDialog here
  Error3, // TODO: alertDialog here
  Unknown
}

extension BattStatusToString on BatteryState {
  String string() => this.toString().split('.').last;
}

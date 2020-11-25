class _BatteryStatusModel {
  final double voltage;
  final double temp;
  final double currentCharge;
  final double currentDischarge;

  const _BatteryStatusModel(
      {this.voltage, this.temp, this.currentCharge, this.currentDischarge});

  factory _BatteryStatusModel.fromJson(Map<String, dynamic> json) =>
      _BatteryStatusModel(
          voltage: json['voltage'],
          temp: json['temp'],
          currentCharge: json['currentCharge'],
          currentDischarge: json['currentDischarge']);
}

class LogModel {
  final String timeStamp;
  final _BatteryStatusModel model;

  const LogModel({this.timeStamp, this.model});

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
      timeStamp: json['timeStamp'],
      model: _BatteryStatusModel.fromJson(json['stats']));
}

class LogFileModel {
  final List<LogModel> logs;

  const LogFileModel({this.logs});

  factory LogFileModel.fromJson(List<dynamic> json) {
    List<LogModel> logs = <LogModel>[];
    logs = json.map((log) => LogModel.fromJson(log)).toList();
    return LogFileModel(logs: logs);
  }
}

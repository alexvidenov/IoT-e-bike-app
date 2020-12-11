// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortStatusModel.dart';

// **************************************************************************
// AutoDataGenerator
// **************************************************************************

@immutable
class ShortStatusModel {
  final double totalVoltage;
  final double currentCharge;
  final double currentDischarge;
  final double temperature;

  const ShortStatusModel({
    @required this.totalVoltage,
    @required this.currentCharge,
    @required this.currentDischarge,
    @required this.temperature,
  });

  ShortStatusModel.empty()
      : totalVoltage = 0,
        currentCharge = 0,
        currentDischarge = 0,
        temperature = 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortStatusModel &&
          runtimeType == other.runtimeType &&
          totalVoltage == other.totalVoltage &&
          currentCharge == other.currentCharge &&
          currentDischarge == other.currentDischarge &&
          temperature == other.temperature;

  @override
  int get hashCode =>
      totalVoltage.hashCode ^
      currentCharge.hashCode ^
      currentDischarge.hashCode ^
      temperature.hashCode;

  @override
  String toString() {
    return 'ShortStatusModel{totalVoltage: ' +
        totalVoltage.toString() +
        ', currentCharge: ' +
        currentCharge.toString() +
        ', currentDischarge: ' +
        currentDischarge.toString() +
        ', temperature: ' +
        temperature.toString() +
        '}';
  }

  ShortStatusModel copyWith({
    double totalVoltage,
    double currentCharge,
    double currentDischarge,
    double temperature,
  }) {
    return ShortStatusModel(
      totalVoltage: totalVoltage ?? this.totalVoltage,
      currentCharge: currentCharge ?? this.currentCharge,
      currentDischarge: currentDischarge ?? this.currentDischarge,
      temperature: temperature ?? this.temperature,
    );
  }

  ShortStatusModel.fromMap(Map<String, dynamic> m)
      : totalVoltage = m['totalVoltage'],
        currentCharge = m['currentCharge'],
        currentDischarge = m['currentDischarge'],
        temperature = m['temperature'];

  Map<String, dynamic> toMap() => {
        'totalVoltage': totalVoltage,
        'currentCharge': currentCharge,
        'currentDischarge': currentDischarge,
        'temperature': temperature
      };

  factory ShortStatusModel.fromJson(String json) =>
      ShortStatusModel.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());
}

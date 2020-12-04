// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortStatusModel.dart';

// **************************************************************************
// AutoDataGenerator
// **************************************************************************

@immutable
class ShortStatusModel {
  final double _totalVoltage;
  final double _currentCharge;
  final double _currentDischarge;
  final double _temperature;

  const ShortStatusModel({
    @required this._totalVoltage,
    @required this._currentCharge,
    @required this._currentDischarge,
    @required this._temperature,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortStatusModel &&
          runtimeType == other.runtimeType &&
          _totalVoltage == other._totalVoltage &&
          _currentCharge == other._currentCharge &&
          _currentDischarge == other._currentDischarge &&
          _temperature == other._temperature;

  @override
  int get hashCode =>
      _totalVoltage.hashCode ^
      _currentCharge.hashCode ^
      _currentDischarge.hashCode ^
      _temperature.hashCode;

  @override
  String toString() {
    return 'ShortStatusModel{_totalVoltage: ' +
        _totalVoltage.toString() +
        ', _currentCharge: ' +
        _currentCharge.toString() +
        ', _currentDischarge: ' +
        _currentDischarge.toString() +
        ', _temperature: ' +
        _temperature.toString() +
        '}';
  }

  ShortStatusModel copyWith({
    double _totalVoltage,
    double _currentCharge,
    double _currentDischarge,
    double _temperature,
  }) {
    return ShortStatusModel(
      _totalVoltage: _totalVoltage ?? this._totalVoltage,
      _currentCharge: _currentCharge ?? this._currentCharge,
      _currentDischarge: _currentDischarge ?? this._currentDischarge,
      _temperature: _temperature ?? this._temperature,
    );
  }

  ShortStatusModel.fromMap(Map<String, dynamic> m)
      : _totalVoltage = m['_totalVoltage'],
        _currentCharge = m['_currentCharge'],
        _currentDischarge = m['_currentDischarge'],
        _temperature = m['_temperature'];

  Map<String, dynamic> toMap() => {
        '_totalVoltage': _totalVoltage,
        '_currentCharge': _currentCharge,
        '_currentDischarge': _currentDischarge,
        '_temperature': _temperature
      };

  factory ShortStatusModel.fromJson(String json) =>
      ShortStatusModel.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());
}

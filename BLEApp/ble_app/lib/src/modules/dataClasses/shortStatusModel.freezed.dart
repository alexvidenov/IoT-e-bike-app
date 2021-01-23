// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'shortStatusModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ShortStatusModelTearOff {
  const _$ShortStatusModelTearOff();

// ignore: unused_element
  _ShortStatus call(
      {double totalVoltage = 0, double current = 0, int temperature = 0}) {
    return _ShortStatus(
      totalVoltage: totalVoltage,
      current: current,
      temperature: temperature,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $ShortStatusModel = _$ShortStatusModelTearOff();

/// @nodoc
mixin _$ShortStatusModel {
  double get totalVoltage;
  double get current;
  int get temperature;

  $ShortStatusModelCopyWith<ShortStatusModel> get copyWith;
}

/// @nodoc
abstract class $ShortStatusModelCopyWith<$Res> {
  factory $ShortStatusModelCopyWith(
          ShortStatusModel value, $Res Function(ShortStatusModel) then) =
      _$ShortStatusModelCopyWithImpl<$Res>;
  $Res call({double totalVoltage, double current, int temperature});
}

/// @nodoc
class _$ShortStatusModelCopyWithImpl<$Res>
    implements $ShortStatusModelCopyWith<$Res> {
  _$ShortStatusModelCopyWithImpl(this._value, this._then);

  final ShortStatusModel _value;
  // ignore: unused_field
  final $Res Function(ShortStatusModel) _then;

  @override
  $Res call({
    Object totalVoltage = freezed,
    Object current = freezed,
    Object temperature = freezed,
  }) {
    return _then(_value.copyWith(
      totalVoltage: totalVoltage == freezed
          ? _value.totalVoltage
          : totalVoltage as double,
      current: current == freezed ? _value.current : current as double,
      temperature:
          temperature == freezed ? _value.temperature : temperature as int,
    ));
  }
}

/// @nodoc
abstract class _$ShortStatusCopyWith<$Res>
    implements $ShortStatusModelCopyWith<$Res> {
  factory _$ShortStatusCopyWith(
          _ShortStatus value, $Res Function(_ShortStatus) then) =
      __$ShortStatusCopyWithImpl<$Res>;
  @override
  $Res call({double totalVoltage, double current, int temperature});
}

/// @nodoc
class __$ShortStatusCopyWithImpl<$Res>
    extends _$ShortStatusModelCopyWithImpl<$Res>
    implements _$ShortStatusCopyWith<$Res> {
  __$ShortStatusCopyWithImpl(
      _ShortStatus _value, $Res Function(_ShortStatus) _then)
      : super(_value, (v) => _then(v as _ShortStatus));

  @override
  _ShortStatus get _value => super._value as _ShortStatus;

  @override
  $Res call({
    Object totalVoltage = freezed,
    Object current = freezed,
    Object temperature = freezed,
  }) {
    return _then(_ShortStatus(
      totalVoltage: totalVoltage == freezed
          ? _value.totalVoltage
          : totalVoltage as double,
      current: current == freezed ? _value.current : current as double,
      temperature:
          temperature == freezed ? _value.temperature : temperature as int,
    ));
  }
}

/// @nodoc
class _$_ShortStatus implements _ShortStatus {
  const _$_ShortStatus(
      {this.totalVoltage = 0, this.current = 0, this.temperature = 0})
      : assert(totalVoltage != null),
        assert(current != null),
        assert(temperature != null);

  @JsonKey(defaultValue: 0)
  @override
  final double totalVoltage;
  @JsonKey(defaultValue: 0)
  @override
  final double current;
  @JsonKey(defaultValue: 0)
  @override
  final int temperature;

  @override
  String toString() {
    return 'ShortStatusModel(totalVoltage: $totalVoltage, current: $current, temperature: $temperature)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ShortStatus &&
            (identical(other.totalVoltage, totalVoltage) ||
                const DeepCollectionEquality()
                    .equals(other.totalVoltage, totalVoltage)) &&
            (identical(other.current, current) ||
                const DeepCollectionEquality()
                    .equals(other.current, current)) &&
            (identical(other.temperature, temperature) ||
                const DeepCollectionEquality()
                    .equals(other.temperature, temperature)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(totalVoltage) ^
      const DeepCollectionEquality().hash(current) ^
      const DeepCollectionEquality().hash(temperature);

  @override
  _$ShortStatusCopyWith<_ShortStatus> get copyWith =>
      __$ShortStatusCopyWithImpl<_ShortStatus>(this, _$identity);
}

abstract class _ShortStatus implements ShortStatusModel {
  const factory _ShortStatus(
      {double totalVoltage, double current, int temperature}) = _$_ShortStatus;

  @override
  double get totalVoltage;
  @override
  double get current;
  @override
  int get temperature;
  @override
  _$ShortStatusCopyWith<_ShortStatus> get copyWith;
}

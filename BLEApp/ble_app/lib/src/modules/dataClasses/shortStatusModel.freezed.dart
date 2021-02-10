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
  ShortStatus call(
      {double totalVoltage = 0, double current = 0, int temperature = 0}) {
    return ShortStatus(
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
abstract class $ShortStatusCopyWith<$Res>
    implements $ShortStatusModelCopyWith<$Res> {
  factory $ShortStatusCopyWith(
          ShortStatus value, $Res Function(ShortStatus) then) =
      _$ShortStatusCopyWithImpl<$Res>;
  @override
  $Res call({double totalVoltage, double current, int temperature});
}

/// @nodoc
class _$ShortStatusCopyWithImpl<$Res>
    extends _$ShortStatusModelCopyWithImpl<$Res>
    implements $ShortStatusCopyWith<$Res> {
  _$ShortStatusCopyWithImpl(
      ShortStatus _value, $Res Function(ShortStatus) _then)
      : super(_value, (v) => _then(v as ShortStatus));

  @override
  ShortStatus get _value => super._value as ShortStatus;

  @override
  $Res call({
    Object totalVoltage = freezed,
    Object current = freezed,
    Object temperature = freezed,
  }) {
    return _then(ShortStatus(
      totalVoltage: totalVoltage == freezed
          ? _value.totalVoltage
          : totalVoltage as double,
      current: current == freezed ? _value.current : current as double,
      temperature:
          temperature == freezed ? _value.temperature : temperature as int,
    ));
  }
}

@Implements(BaseModel)

/// @nodoc
class _$ShortStatus implements ShortStatus {
  const _$ShortStatus(
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
  LogModel generate() => LogModel.fromJson({
      'timeStamp' : DateTime.now().toString(),
      'voltage' : this.totalVoltage,
      'current' : this.current,
      'temp' : this.temperature
    });

  @override
  String toString() {
    return 'ShortStatusModel(totalVoltage: $totalVoltage, current: $current, temperature: $temperature)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ShortStatus &&
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
  $ShortStatusCopyWith<ShortStatus> get copyWith =>
      _$ShortStatusCopyWithImpl<ShortStatus>(this, _$identity);
}

abstract class ShortStatus implements ShortStatusModel, BaseModel {
  const factory ShortStatus(
      {double totalVoltage, double current, int temperature}) = _$ShortStatus;

  @override
  double get totalVoltage;
  @override
  double get current;
  @override
  int get temperature;
  @override
  LogModel generate();
  @override
  $ShortStatusCopyWith<ShortStatus> get copyWith;
}

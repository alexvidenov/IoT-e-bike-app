// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'fullStatusModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$FullStatusModelTearOff {
  const _$FullStatusModelTearOff();

// ignore: unused_element
  FullStatus call(
      {List<FullStatusDataModel> fullStatus = const [],
      double totalVoltage = 0,
      double current = 0,
      int temperature = 0,
      double delta = 0}) {
    return FullStatus(
      fullStatus: fullStatus,
      totalVoltage: totalVoltage,
      current: current,
      temperature: temperature,
      delta: delta,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $FullStatusModel = _$FullStatusModelTearOff();

/// @nodoc
mixin _$FullStatusModel {
  List<FullStatusDataModel> get fullStatus;
  double get totalVoltage;
  double get current;
  int get temperature;
  double get delta;

  $FullStatusModelCopyWith<FullStatusModel> get copyWith;
}

/// @nodoc
abstract class $FullStatusModelCopyWith<$Res> {
  factory $FullStatusModelCopyWith(
          FullStatusModel value, $Res Function(FullStatusModel) then) =
      _$FullStatusModelCopyWithImpl<$Res>;
  $Res call(
      {List<FullStatusDataModel> fullStatus,
      double totalVoltage,
      double current,
      int temperature,
      double delta});
}

/// @nodoc
class _$FullStatusModelCopyWithImpl<$Res>
    implements $FullStatusModelCopyWith<$Res> {
  _$FullStatusModelCopyWithImpl(this._value, this._then);

  final FullStatusModel _value;
  // ignore: unused_field
  final $Res Function(FullStatusModel) _then;

  @override
  $Res call({
    Object fullStatus = freezed,
    Object totalVoltage = freezed,
    Object current = freezed,
    Object temperature = freezed,
    Object delta = freezed,
  }) {
    return _then(_value.copyWith(
      fullStatus: fullStatus == freezed
          ? _value.fullStatus
          : fullStatus as List<FullStatusDataModel>,
      totalVoltage: totalVoltage == freezed
          ? _value.totalVoltage
          : totalVoltage as double,
      current: current == freezed ? _value.current : current as double,
      temperature:
          temperature == freezed ? _value.temperature : temperature as int,
      delta: delta == freezed ? _value.delta : delta as double,
    ));
  }
}

/// @nodoc
abstract class $FullStatusCopyWith<$Res>
    implements $FullStatusModelCopyWith<$Res> {
  factory $FullStatusCopyWith(
          FullStatus value, $Res Function(FullStatus) then) =
      _$FullStatusCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<FullStatusDataModel> fullStatus,
      double totalVoltage,
      double current,
      int temperature,
      double delta});
}

/// @nodoc
class _$FullStatusCopyWithImpl<$Res> extends _$FullStatusModelCopyWithImpl<$Res>
    implements $FullStatusCopyWith<$Res> {
  _$FullStatusCopyWithImpl(FullStatus _value, $Res Function(FullStatus) _then)
      : super(_value, (v) => _then(v as FullStatus));

  @override
  FullStatus get _value => super._value as FullStatus;

  @override
  $Res call({
    Object fullStatus = freezed,
    Object totalVoltage = freezed,
    Object current = freezed,
    Object temperature = freezed,
    Object delta = freezed,
  }) {
    return _then(FullStatus(
      fullStatus: fullStatus == freezed
          ? _value.fullStatus
          : fullStatus as List<FullStatusDataModel>,
      totalVoltage: totalVoltage == freezed
          ? _value.totalVoltage
          : totalVoltage as double,
      current: current == freezed ? _value.current : current as double,
      temperature:
          temperature == freezed ? _value.temperature : temperature as int,
      delta: delta == freezed ? _value.delta : delta as double,
    ));
  }
}

@Implements(BaseModel)

/// @nodoc
class _$FullStatus implements FullStatus {
  const _$FullStatus(
      {this.fullStatus = const [],
      this.totalVoltage = 0,
      this.current = 0,
      this.temperature = 0,
      this.delta = 0})
      : assert(fullStatus != null),
        assert(totalVoltage != null),
        assert(current != null),
        assert(temperature != null),
        assert(delta != null);

  @JsonKey(defaultValue: const [])
  @override
  final List<FullStatusDataModel> fullStatus;
  @JsonKey(defaultValue: 0)
  @override
  final double totalVoltage;
  @JsonKey(defaultValue: 0)
  @override
  final double current;
  @JsonKey(defaultValue: 0)
  @override
  final int temperature;
  @JsonKey(defaultValue: 0)
  @override
  final double delta;

  @override
  LogModel generate() => LogModel.fromJson({
    'timeStamp' : DateTime.now(),
    'voltage' : this.totalVoltage,
    'current' : this.current,
    'temp' : this.temperature,
    'delta' : this.delta
  });

  @override
  String toString() {
    return 'FullStatusModel(fullStatus: $fullStatus, totalVoltage: $totalVoltage, current: $current, temperature: $temperature, delta: $delta)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FullStatus &&
            (identical(other.fullStatus, fullStatus) ||
                const DeepCollectionEquality()
                    .equals(other.fullStatus, fullStatus)) &&
            (identical(other.totalVoltage, totalVoltage) ||
                const DeepCollectionEquality()
                    .equals(other.totalVoltage, totalVoltage)) &&
            (identical(other.current, current) ||
                const DeepCollectionEquality()
                    .equals(other.current, current)) &&
            (identical(other.temperature, temperature) ||
                const DeepCollectionEquality()
                    .equals(other.temperature, temperature)) &&
            (identical(other.delta, delta) ||
                const DeepCollectionEquality().equals(other.delta, delta)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(fullStatus) ^
      const DeepCollectionEquality().hash(totalVoltage) ^
      const DeepCollectionEquality().hash(current) ^
      const DeepCollectionEquality().hash(temperature) ^
      const DeepCollectionEquality().hash(delta);

  @override
  $FullStatusCopyWith<FullStatus> get copyWith =>
      _$FullStatusCopyWithImpl<FullStatus>(this, _$identity);
}

abstract class FullStatus implements FullStatusModel, BaseModel {
  const factory FullStatus(
      {List<FullStatusDataModel> fullStatus,
      double totalVoltage,
      double current,
      int temperature,
      double delta}) = _$FullStatus;

  @override
  List<FullStatusDataModel> get fullStatus;
  @override
  double get totalVoltage;
  @override
  double get current;
  @override
  int get temperature;
  @override
  double get delta;
  @override
  LogModel generate();
  @override
  $FullStatusCopyWith<FullStatus> get copyWith;
}

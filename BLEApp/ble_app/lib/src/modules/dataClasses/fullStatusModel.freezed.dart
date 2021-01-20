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
  _FullStatus call(
      List<FullStatusDataModel> fullStatus,
      double totalVoltage,
      double current,
      double temperature,
      double lowCurrentDelta,
      double highCurrentDelta,
      int rIn,
      BattStatus status) {
    return _FullStatus(
      fullStatus,
      totalVoltage,
      current,
      temperature,
      lowCurrentDelta,
      highCurrentDelta,
      rIn,
      status,
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
  double get current; // extract into its own holder class (or enum)
  double get temperature;
  double get lowCurrentDelta;
  double get highCurrentDelta;
  int get rIn;
  BattStatus get status;

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
      double temperature,
      double lowCurrentDelta,
      double highCurrentDelta,
      int rIn,
      BattStatus status});
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
    Object lowCurrentDelta = freezed,
    Object highCurrentDelta = freezed,
    Object rIn = freezed,
    Object status = freezed,
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
          temperature == freezed ? _value.temperature : temperature as double,
      lowCurrentDelta: lowCurrentDelta == freezed
          ? _value.lowCurrentDelta
          : lowCurrentDelta as double,
      highCurrentDelta: highCurrentDelta == freezed
          ? _value.highCurrentDelta
          : highCurrentDelta as double,
      rIn: rIn == freezed ? _value.rIn : rIn as int,
      status: status == freezed ? _value.status : status as BattStatus,
    ));
  }
}

/// @nodoc
abstract class _$FullStatusCopyWith<$Res>
    implements $FullStatusModelCopyWith<$Res> {
  factory _$FullStatusCopyWith(
          _FullStatus value, $Res Function(_FullStatus) then) =
      __$FullStatusCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<FullStatusDataModel> fullStatus,
      double totalVoltage,
      double current,
      double temperature,
      double lowCurrentDelta,
      double highCurrentDelta,
      int rIn,
      BattStatus status});
}

/// @nodoc
class __$FullStatusCopyWithImpl<$Res>
    extends _$FullStatusModelCopyWithImpl<$Res>
    implements _$FullStatusCopyWith<$Res> {
  __$FullStatusCopyWithImpl(
      _FullStatus _value, $Res Function(_FullStatus) _then)
      : super(_value, (v) => _then(v as _FullStatus));

  @override
  _FullStatus get _value => super._value as _FullStatus;

  @override
  $Res call({
    Object fullStatus = freezed,
    Object totalVoltage = freezed,
    Object current = freezed,
    Object temperature = freezed,
    Object lowCurrentDelta = freezed,
    Object highCurrentDelta = freezed,
    Object rIn = freezed,
    Object status = freezed,
  }) {
    return _then(_FullStatus(
      fullStatus == freezed
          ? _value.fullStatus
          : fullStatus as List<FullStatusDataModel>,
      totalVoltage == freezed ? _value.totalVoltage : totalVoltage as double,
      current == freezed ? _value.current : current as double,
      temperature == freezed ? _value.temperature : temperature as double,
      lowCurrentDelta == freezed
          ? _value.lowCurrentDelta
          : lowCurrentDelta as double,
      highCurrentDelta == freezed
          ? _value.highCurrentDelta
          : highCurrentDelta as double,
      rIn == freezed ? _value.rIn : rIn as int,
      status == freezed ? _value.status : status as BattStatus,
    ));
  }
}

/// @nodoc
class _$_FullStatus implements _FullStatus {
  const _$_FullStatus(
      this.fullStatus,
      this.totalVoltage,
      this.current,
      this.temperature,
      this.lowCurrentDelta,
      this.highCurrentDelta,
      this.rIn,
      this.status)
      : assert(fullStatus != null),
        assert(totalVoltage != null),
        assert(current != null),
        assert(temperature != null),
        assert(lowCurrentDelta != null),
        assert(highCurrentDelta != null),
        assert(rIn != null),
        assert(status != null);

  @override
  final List<FullStatusDataModel> fullStatus;
  @override
  final double totalVoltage;
  @override
  final double current;
  @override // extract into its own holder class (or enum)
  final double temperature;
  @override
  final double lowCurrentDelta;
  @override
  final double highCurrentDelta;
  @override
  final int rIn;
  @override
  final BattStatus status;

  @override
  String toString() {
    return 'FullStatusModel(fullStatus: $fullStatus, totalVoltage: $totalVoltage, current: $current, temperature: $temperature, lowCurrentDelta: $lowCurrentDelta, highCurrentDelta: $highCurrentDelta, rIn: $rIn, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FullStatus &&
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
            (identical(other.lowCurrentDelta, lowCurrentDelta) ||
                const DeepCollectionEquality()
                    .equals(other.lowCurrentDelta, lowCurrentDelta)) &&
            (identical(other.highCurrentDelta, highCurrentDelta) ||
                const DeepCollectionEquality()
                    .equals(other.highCurrentDelta, highCurrentDelta)) &&
            (identical(other.rIn, rIn) ||
                const DeepCollectionEquality().equals(other.rIn, rIn)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(fullStatus) ^
      const DeepCollectionEquality().hash(totalVoltage) ^
      const DeepCollectionEquality().hash(current) ^
      const DeepCollectionEquality().hash(temperature) ^
      const DeepCollectionEquality().hash(lowCurrentDelta) ^
      const DeepCollectionEquality().hash(highCurrentDelta) ^
      const DeepCollectionEquality().hash(rIn) ^
      const DeepCollectionEquality().hash(status);

  @override
  _$FullStatusCopyWith<_FullStatus> get copyWith =>
      __$FullStatusCopyWithImpl<_FullStatus>(this, _$identity);
}

abstract class _FullStatus implements FullStatusModel {
  const factory _FullStatus(
      List<FullStatusDataModel> fullStatus,
      double totalVoltage,
      double current,
      double temperature,
      double lowCurrentDelta,
      double highCurrentDelta,
      int rIn,
      BattStatus status) = _$_FullStatus;

  @override
  List<FullStatusDataModel> get fullStatus;
  @override
  double get totalVoltage;
  @override
  double get current;
  @override // extract into its own holder class (or enum)
  double get temperature;
  @override
  double get lowCurrentDelta;
  @override
  double get highCurrentDelta;
  @override
  int get rIn;
  @override
  BattStatus get status;
  @override
  _$FullStatusCopyWith<_FullStatus> get copyWith;
}

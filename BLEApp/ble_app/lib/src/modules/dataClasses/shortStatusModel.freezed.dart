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
  _ShortStatus call(double totalVoltage, double current, double temperature) {
    return _ShortStatus(
      totalVoltage,
      current,
      temperature,
    );
  }

// ignore: unused_element
  _EmptyShortStatus empty(
      [double totalVoltage = 0, double current = 0, double temperature = 0]) {
    return _EmptyShortStatus(
      totalVoltage,
      current,
      temperature,
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
  double get temperature;

  @optionalTypeArgs
  TResult when<TResult extends Object>(
    TResult $default(double totalVoltage, double current, double temperature), {
    @required
        TResult empty(double totalVoltage, double current, double temperature),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(double totalVoltage, double current, double temperature), {
    TResult empty(double totalVoltage, double current, double temperature),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(_ShortStatus value), {
    @required TResult empty(_EmptyShortStatus value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(_ShortStatus value), {
    TResult empty(_EmptyShortStatus value),
    @required TResult orElse(),
  });

  $ShortStatusModelCopyWith<ShortStatusModel> get copyWith;
}

/// @nodoc
abstract class $ShortStatusModelCopyWith<$Res> {
  factory $ShortStatusModelCopyWith(
          ShortStatusModel value, $Res Function(ShortStatusModel) then) =
      _$ShortStatusModelCopyWithImpl<$Res>;
  $Res call({double totalVoltage, double current, double temperature});
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
          temperature == freezed ? _value.temperature : temperature as double,
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
  $Res call({double totalVoltage, double current, double temperature});
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
      totalVoltage == freezed ? _value.totalVoltage : totalVoltage as double,
      current == freezed ? _value.current : current as double,
      temperature == freezed ? _value.temperature : temperature as double,
    ));
  }
}

/// @nodoc
class _$_ShortStatus implements _ShortStatus {
  const _$_ShortStatus(this.totalVoltage, this.current, this.temperature)
      : assert(totalVoltage != null),
        assert(current != null),
        assert(temperature != null);

  @override
  final double totalVoltage;
  @override
  final double current;
  @override
  final double temperature;

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

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>(
    TResult $default(double totalVoltage, double current, double temperature), {
    @required
        TResult empty(double totalVoltage, double current, double temperature),
  }) {
    assert($default != null);
    assert(empty != null);
    return $default(totalVoltage, current, temperature);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(double totalVoltage, double current, double temperature), {
    TResult empty(double totalVoltage, double current, double temperature),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(totalVoltage, current, temperature);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(_ShortStatus value), {
    @required TResult empty(_EmptyShortStatus value),
  }) {
    assert($default != null);
    assert(empty != null);
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(_ShortStatus value), {
    TResult empty(_EmptyShortStatus value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _ShortStatus implements ShortStatusModel {
  const factory _ShortStatus(
      double totalVoltage, double current, double temperature) = _$_ShortStatus;

  @override
  double get totalVoltage;
  @override
  double get current;
  @override
  double get temperature;
  @override
  _$ShortStatusCopyWith<_ShortStatus> get copyWith;
}

/// @nodoc
abstract class _$EmptyShortStatusCopyWith<$Res>
    implements $ShortStatusModelCopyWith<$Res> {
  factory _$EmptyShortStatusCopyWith(
          _EmptyShortStatus value, $Res Function(_EmptyShortStatus) then) =
      __$EmptyShortStatusCopyWithImpl<$Res>;
  @override
  $Res call({double totalVoltage, double current, double temperature});
}

/// @nodoc
class __$EmptyShortStatusCopyWithImpl<$Res>
    extends _$ShortStatusModelCopyWithImpl<$Res>
    implements _$EmptyShortStatusCopyWith<$Res> {
  __$EmptyShortStatusCopyWithImpl(
      _EmptyShortStatus _value, $Res Function(_EmptyShortStatus) _then)
      : super(_value, (v) => _then(v as _EmptyShortStatus));

  @override
  _EmptyShortStatus get _value => super._value as _EmptyShortStatus;

  @override
  $Res call({
    Object totalVoltage = freezed,
    Object current = freezed,
    Object temperature = freezed,
  }) {
    return _then(_EmptyShortStatus(
      totalVoltage == freezed ? _value.totalVoltage : totalVoltage as double,
      current == freezed ? _value.current : current as double,
      temperature == freezed ? _value.temperature : temperature as double,
    ));
  }
}

/// @nodoc
class _$_EmptyShortStatus implements _EmptyShortStatus {
  const _$_EmptyShortStatus(
      [this.totalVoltage = 0, this.current = 0, this.temperature = 0])
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
  final double temperature;

  @override
  String toString() {
    return 'ShortStatusModel.empty(totalVoltage: $totalVoltage, current: $current, temperature: $temperature)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _EmptyShortStatus &&
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
  _$EmptyShortStatusCopyWith<_EmptyShortStatus> get copyWith =>
      __$EmptyShortStatusCopyWithImpl<_EmptyShortStatus>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>(
    TResult $default(double totalVoltage, double current, double temperature), {
    @required
        TResult empty(double totalVoltage, double current, double temperature),
  }) {
    assert($default != null);
    assert(empty != null);
    return empty(totalVoltage, current, temperature);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(double totalVoltage, double current, double temperature), {
    TResult empty(double totalVoltage, double current, double temperature),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (empty != null) {
      return empty(totalVoltage, current, temperature);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(_ShortStatus value), {
    @required TResult empty(_EmptyShortStatus value),
  }) {
    assert($default != null);
    assert(empty != null);
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(_ShortStatus value), {
    TResult empty(_EmptyShortStatus value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _EmptyShortStatus implements ShortStatusModel {
  const factory _EmptyShortStatus(
      [double totalVoltage,
      double current,
      double temperature]) = _$_EmptyShortStatus;

  @override
  double get totalVoltage;
  @override
  double get current;
  @override
  double get temperature;
  @override
  _$EmptyShortStatusCopyWith<_EmptyShortStatus> get copyWith;
}

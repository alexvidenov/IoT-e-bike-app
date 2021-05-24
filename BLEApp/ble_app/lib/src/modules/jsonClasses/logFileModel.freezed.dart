// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'logFileModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
LogModel _$LogModelFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType'] as String) {
    case 'short':
      return ShortLogmodel.fromJson(json);
    case 'full':
      return FullLogModel.fromJson(json);

    default:
      throw FallThroughError();
  }
}

/// @nodoc
class _$LogModelTearOff {
  const _$LogModelTearOff();

// ignore: unused_element
  ShortLogmodel short(
      {String timeStamp, double voltage, double current, int temp}) {
    return ShortLogmodel(
      timeStamp: timeStamp,
      voltage: voltage,
      current: current,
      temp: temp,
    );
  }

// ignore: unused_element
  FullLogModel full(
      {String timeStamp,
      double voltage,
      double current,
      int temp,
      double delta}) {
    return FullLogModel(
      timeStamp: timeStamp,
      voltage: voltage,
      current: current,
      temp: temp,
      delta: delta,
    );
  }

// ignore: unused_element
  LogModel fromJson(Map<String, Object> json) {
    return LogModel.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $LogModel = _$LogModelTearOff();

/// @nodoc
mixin _$LogModel {
  String get timeStamp;
  double get voltage;
  double get current;
  int get temp;

  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult short(
            String timeStamp, double voltage, double current, int temp),
    @required
        TResult full(String timeStamp, double voltage, double current, int temp,
            double delta),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult short(String timeStamp, double voltage, double current, int temp),
    TResult full(String timeStamp, double voltage, double current, int temp,
        double delta),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult short(ShortLogmodel value),
    @required TResult full(FullLogModel value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult short(ShortLogmodel value),
    TResult full(FullLogModel value),
    @required TResult orElse(),
  });
  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $LogModelCopyWith<LogModel> get copyWith;
}

/// @nodoc
abstract class $LogModelCopyWith<$Res> {
  factory $LogModelCopyWith(LogModel value, $Res Function(LogModel) then) =
      _$LogModelCopyWithImpl<$Res>;
  $Res call({String timeStamp, double voltage, double current, int temp});
}

/// @nodoc
class _$LogModelCopyWithImpl<$Res> implements $LogModelCopyWith<$Res> {
  _$LogModelCopyWithImpl(this._value, this._then);

  final LogModel _value;
  // ignore: unused_field
  final $Res Function(LogModel) _then;

  @override
  $Res call({
    Object timeStamp = freezed,
    Object voltage = freezed,
    Object current = freezed,
    Object temp = freezed,
  }) {
    return _then(_value.copyWith(
      timeStamp: timeStamp == freezed ? _value.timeStamp : timeStamp as String,
      voltage: voltage == freezed ? _value.voltage : voltage as double,
      current: current == freezed ? _value.current : current as double,
      temp: temp == freezed ? _value.temp : temp as int,
    ));
  }
}

/// @nodoc
abstract class $ShortLogmodelCopyWith<$Res> implements $LogModelCopyWith<$Res> {
  factory $ShortLogmodelCopyWith(
          ShortLogmodel value, $Res Function(ShortLogmodel) then) =
      _$ShortLogmodelCopyWithImpl<$Res>;
  @override
  $Res call({String timeStamp, double voltage, double current, int temp});
}

/// @nodoc
class _$ShortLogmodelCopyWithImpl<$Res> extends _$LogModelCopyWithImpl<$Res>
    implements $ShortLogmodelCopyWith<$Res> {
  _$ShortLogmodelCopyWithImpl(
      ShortLogmodel _value, $Res Function(ShortLogmodel) _then)
      : super(_value, (v) => _then(v as ShortLogmodel));

  @override
  ShortLogmodel get _value => super._value as ShortLogmodel;

  @override
  $Res call({
    Object timeStamp = freezed,
    Object voltage = freezed,
    Object current = freezed,
    Object temp = freezed,
  }) {
    return _then(ShortLogmodel(
      timeStamp: timeStamp == freezed ? _value.timeStamp : timeStamp as String,
      voltage: voltage == freezed ? _value.voltage : voltage as double,
      current: current == freezed ? _value.current : current as double,
      temp: temp == freezed ? _value.temp : temp as int,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$ShortLogmodel implements ShortLogmodel {
  const _$ShortLogmodel(
      {this.timeStamp, this.voltage, this.current, this.temp});

  factory _$ShortLogmodel.fromJson(Map<String, dynamic> json) =>
      _$_$ShortLogmodelFromJson(json);

  @override
  final String timeStamp;
  @override
  final double voltage;
  @override
  final double current;
  @override
  final int temp;

  @override
  String toString() {
    return 'LogModel.short(timeStamp: $timeStamp, voltage: $voltage, current: $current, temp: $temp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ShortLogmodel &&
            (identical(other.timeStamp, timeStamp) ||
                const DeepCollectionEquality()
                    .equals(other.timeStamp, timeStamp)) &&
            (identical(other.voltage, voltage) ||
                const DeepCollectionEquality()
                    .equals(other.voltage, voltage)) &&
            (identical(other.current, current) ||
                const DeepCollectionEquality()
                    .equals(other.current, current)) &&
            (identical(other.temp, temp) ||
                const DeepCollectionEquality().equals(other.temp, temp)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(timeStamp) ^
      const DeepCollectionEquality().hash(voltage) ^
      const DeepCollectionEquality().hash(current) ^
      const DeepCollectionEquality().hash(temp);

  @JsonKey(ignore: true)
  @override
  $ShortLogmodelCopyWith<ShortLogmodel> get copyWith =>
      _$ShortLogmodelCopyWithImpl<ShortLogmodel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult short(
            String timeStamp, double voltage, double current, int temp),
    @required
        TResult full(String timeStamp, double voltage, double current, int temp,
            double delta),
  }) {
    assert(short != null);
    assert(full != null);
    return short(timeStamp, voltage, current, temp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult short(String timeStamp, double voltage, double current, int temp),
    TResult full(String timeStamp, double voltage, double current, int temp,
        double delta),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (short != null) {
      return short(timeStamp, voltage, current, temp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult short(ShortLogmodel value),
    @required TResult full(FullLogModel value),
  }) {
    assert(short != null);
    assert(full != null);
    return short(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult short(ShortLogmodel value),
    TResult full(FullLogModel value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (short != null) {
      return short(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$ShortLogmodelToJson(this)..['runtimeType'] = 'short';
  }
}

abstract class ShortLogmodel implements LogModel {
  const factory ShortLogmodel(
      {String timeStamp,
      double voltage,
      double current,
      int temp}) = _$ShortLogmodel;

  factory ShortLogmodel.fromJson(Map<String, dynamic> json) =
      _$ShortLogmodel.fromJson;

  @override
  String get timeStamp;
  @override
  double get voltage;
  @override
  double get current;
  @override
  int get temp;
  @override
  @JsonKey(ignore: true)
  $ShortLogmodelCopyWith<ShortLogmodel> get copyWith;
}

/// @nodoc
abstract class $FullLogModelCopyWith<$Res> implements $LogModelCopyWith<$Res> {
  factory $FullLogModelCopyWith(
          FullLogModel value, $Res Function(FullLogModel) then) =
      _$FullLogModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String timeStamp,
      double voltage,
      double current,
      int temp,
      double delta});
}

/// @nodoc
class _$FullLogModelCopyWithImpl<$Res> extends _$LogModelCopyWithImpl<$Res>
    implements $FullLogModelCopyWith<$Res> {
  _$FullLogModelCopyWithImpl(
      FullLogModel _value, $Res Function(FullLogModel) _then)
      : super(_value, (v) => _then(v as FullLogModel));

  @override
  FullLogModel get _value => super._value as FullLogModel;

  @override
  $Res call({
    Object timeStamp = freezed,
    Object voltage = freezed,
    Object current = freezed,
    Object temp = freezed,
    Object delta = freezed,
  }) {
    return _then(FullLogModel(
      timeStamp: timeStamp == freezed ? _value.timeStamp : timeStamp as String,
      voltage: voltage == freezed ? _value.voltage : voltage as double,
      current: current == freezed ? _value.current : current as double,
      temp: temp == freezed ? _value.temp : temp as int,
      delta: delta == freezed ? _value.delta : delta as double,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$FullLogModel implements FullLogModel {
  const _$FullLogModel(
      {this.timeStamp, this.voltage, this.current, this.temp, this.delta});

  factory _$FullLogModel.fromJson(Map<String, dynamic> json) =>
      _$_$FullLogModelFromJson(json);

  @override
  final String timeStamp;
  @override
  final double voltage;
  @override
  final double current;
  @override
  final int temp;
  @override
  final double delta;

  @override
  String toString() {
    return 'LogModel.full(timeStamp: $timeStamp, voltage: $voltage, current: $current, temp: $temp, delta: $delta)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FullLogModel &&
            (identical(other.timeStamp, timeStamp) ||
                const DeepCollectionEquality()
                    .equals(other.timeStamp, timeStamp)) &&
            (identical(other.voltage, voltage) ||
                const DeepCollectionEquality()
                    .equals(other.voltage, voltage)) &&
            (identical(other.current, current) ||
                const DeepCollectionEquality()
                    .equals(other.current, current)) &&
            (identical(other.temp, temp) ||
                const DeepCollectionEquality().equals(other.temp, temp)) &&
            (identical(other.delta, delta) ||
                const DeepCollectionEquality().equals(other.delta, delta)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(timeStamp) ^
      const DeepCollectionEquality().hash(voltage) ^
      const DeepCollectionEquality().hash(current) ^
      const DeepCollectionEquality().hash(temp) ^
      const DeepCollectionEquality().hash(delta);

  @JsonKey(ignore: true)
  @override
  $FullLogModelCopyWith<FullLogModel> get copyWith =>
      _$FullLogModelCopyWithImpl<FullLogModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required
        TResult short(
            String timeStamp, double voltage, double current, int temp),
    @required
        TResult full(String timeStamp, double voltage, double current, int temp,
            double delta),
  }) {
    assert(short != null);
    assert(full != null);
    return full(timeStamp, voltage, current, temp, delta);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult short(String timeStamp, double voltage, double current, int temp),
    TResult full(String timeStamp, double voltage, double current, int temp,
        double delta),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (full != null) {
      return full(timeStamp, voltage, current, temp, delta);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult short(ShortLogmodel value),
    @required TResult full(FullLogModel value),
  }) {
    assert(short != null);
    assert(full != null);
    return full(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult short(ShortLogmodel value),
    TResult full(FullLogModel value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (full != null) {
      return full(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$FullLogModelToJson(this)..['runtimeType'] = 'full';
  }
}

abstract class FullLogModel implements LogModel {
  const factory FullLogModel(
      {String timeStamp,
      double voltage,
      double current,
      int temp,
      double delta}) = _$FullLogModel;

  factory FullLogModel.fromJson(Map<String, dynamic> json) =
      _$FullLogModel.fromJson;

  @override
  String get timeStamp;
  @override
  double get voltage;
  @override
  double get current;
  @override
  int get temp;
  double get delta;
  @override
  @JsonKey(ignore: true)
  $FullLogModelCopyWith<FullLogModel> get copyWith;
}

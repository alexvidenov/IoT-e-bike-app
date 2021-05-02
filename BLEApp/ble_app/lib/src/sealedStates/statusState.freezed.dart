// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'statusState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$StatusStateTearOff {
  const _$StatusStateTearOff();

// ignore: unused_element
  Status<T> call<T extends BaseModel>(BatteryState state, [T model]) {
    return Status<T>(
      state,
      model,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $StatusState = _$StatusStateTearOff();

/// @nodoc
mixin _$StatusState<T extends BaseModel> {
  BatteryState get state;
  T get model;

  @JsonKey(ignore: true)
  $StatusStateCopyWith<T, StatusState<T>> get copyWith;
}

/// @nodoc
abstract class $StatusStateCopyWith<T extends BaseModel, $Res> {
  factory $StatusStateCopyWith(
          StatusState<T> value, $Res Function(StatusState<T>) then) =
      _$StatusStateCopyWithImpl<T, $Res>;
  $Res call({BatteryState state, T model});
}

/// @nodoc
class _$StatusStateCopyWithImpl<T extends BaseModel, $Res>
    implements $StatusStateCopyWith<T, $Res> {
  _$StatusStateCopyWithImpl(this._value, this._then);

  final StatusState<T> _value;
  // ignore: unused_field
  final $Res Function(StatusState<T>) _then;

  @override
  $Res call({
    Object state = freezed,
    Object model = freezed,
  }) {
    return _then(_value.copyWith(
      state: state == freezed ? _value.state : state as BatteryState,
      model: model == freezed ? _value.model : model as T,
    ));
  }
}

/// @nodoc
abstract class $StatusCopyWith<T extends BaseModel, $Res>
    implements $StatusStateCopyWith<T, $Res> {
  factory $StatusCopyWith(Status<T> value, $Res Function(Status<T>) then) =
      _$StatusCopyWithImpl<T, $Res>;
  @override
  $Res call({BatteryState state, T model});
}

/// @nodoc
class _$StatusCopyWithImpl<T extends BaseModel, $Res>
    extends _$StatusStateCopyWithImpl<T, $Res>
    implements $StatusCopyWith<T, $Res> {
  _$StatusCopyWithImpl(Status<T> _value, $Res Function(Status<T>) _then)
      : super(_value, (v) => _then(v as Status<T>));

  @override
  Status<T> get _value => super._value as Status<T>;

  @override
  $Res call({
    Object state = freezed,
    Object model = freezed,
  }) {
    return _then(Status<T>(
      state == freezed ? _value.state : state as BatteryState,
      model == freezed ? _value.model : model as T,
    ));
  }
}

@With.fromString('BaseStatus<T>')

/// @nodoc
class _$Status<T extends BaseModel> with BaseStatus<T> implements Status<T> {
  const _$Status(this.state, [this.model]) : assert(state != null);

  @override
  final BatteryState state;
  @override
  final T model;

  @override
  String toString() {
    return 'StatusState<$T>(state: $state, model: $model)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Status<T> &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.model, model) ||
                const DeepCollectionEquality().equals(other.model, model)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(model);

  @JsonKey(ignore: true)
  @override
  $StatusCopyWith<T, Status<T>> get copyWith =>
      _$StatusCopyWithImpl<T, Status<T>>(this, _$identity);
}

abstract class Status<T extends BaseModel>
    implements StatusState<T>, BaseStatus<T> {
  const factory Status(BatteryState state, [T model]) = _$Status<T>;

  @override
  BatteryState get state;
  @override
  T get model;
  @override
  @JsonKey(ignore: true)
  $StatusCopyWith<T, Status<T>> get copyWith;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'deviceConnectionState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$DeviceConnectionStateTearOff {
  const _$DeviceConnectionStateTearOff();

// ignore: unused_element
  _NormalBTState normalBTState({PeripheralConnectionState state}) {
    return _NormalBTState(
      state: state,
    );
  }

// ignore: unused_element
  _BLEException bleException({BleError e}) {
    return _BLEException(
      e: e,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $DeviceConnectionState = _$DeviceConnectionStateTearOff();

/// @nodoc
mixin _$DeviceConnectionState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult normalBTState(PeripheralConnectionState state),
    @required TResult bleException(BleError e),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult normalBTState(PeripheralConnectionState state),
    TResult bleException(BleError e),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult normalBTState(_NormalBTState value),
    @required TResult bleException(_BLEException value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult normalBTState(_NormalBTState value),
    TResult bleException(_BLEException value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $DeviceConnectionStateCopyWith<$Res> {
  factory $DeviceConnectionStateCopyWith(DeviceConnectionState value,
          $Res Function(DeviceConnectionState) then) =
      _$DeviceConnectionStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$DeviceConnectionStateCopyWithImpl<$Res>
    implements $DeviceConnectionStateCopyWith<$Res> {
  _$DeviceConnectionStateCopyWithImpl(this._value, this._then);

  final DeviceConnectionState _value;
  // ignore: unused_field
  final $Res Function(DeviceConnectionState) _then;
}

/// @nodoc
abstract class _$NormalBTStateCopyWith<$Res> {
  factory _$NormalBTStateCopyWith(
          _NormalBTState value, $Res Function(_NormalBTState) then) =
      __$NormalBTStateCopyWithImpl<$Res>;
  $Res call({PeripheralConnectionState state});
}

/// @nodoc
class __$NormalBTStateCopyWithImpl<$Res>
    extends _$DeviceConnectionStateCopyWithImpl<$Res>
    implements _$NormalBTStateCopyWith<$Res> {
  __$NormalBTStateCopyWithImpl(
      _NormalBTState _value, $Res Function(_NormalBTState) _then)
      : super(_value, (v) => _then(v as _NormalBTState));

  @override
  _NormalBTState get _value => super._value as _NormalBTState;

  @override
  $Res call({
    Object state = freezed,
  }) {
    return _then(_NormalBTState(
      state:
          state == freezed ? _value.state : state as PeripheralConnectionState,
    ));
  }
}

/// @nodoc
class _$_NormalBTState implements _NormalBTState {
  const _$_NormalBTState({this.state});

  @override
  final PeripheralConnectionState state;

  @override
  String toString() {
    return 'DeviceConnectionState.normalBTState(state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _NormalBTState &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(state);

  @JsonKey(ignore: true)
  @override
  _$NormalBTStateCopyWith<_NormalBTState> get copyWith =>
      __$NormalBTStateCopyWithImpl<_NormalBTState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult normalBTState(PeripheralConnectionState state),
    @required TResult bleException(BleError e),
  }) {
    assert(normalBTState != null);
    assert(bleException != null);
    return normalBTState(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult normalBTState(PeripheralConnectionState state),
    TResult bleException(BleError e),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (normalBTState != null) {
      return normalBTState(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult normalBTState(_NormalBTState value),
    @required TResult bleException(_BLEException value),
  }) {
    assert(normalBTState != null);
    assert(bleException != null);
    return normalBTState(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult normalBTState(_NormalBTState value),
    TResult bleException(_BLEException value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (normalBTState != null) {
      return normalBTState(this);
    }
    return orElse();
  }
}

abstract class _NormalBTState implements DeviceConnectionState {
  const factory _NormalBTState({PeripheralConnectionState state}) =
      _$_NormalBTState;

  PeripheralConnectionState get state;
  @JsonKey(ignore: true)
  _$NormalBTStateCopyWith<_NormalBTState> get copyWith;
}

/// @nodoc
abstract class _$BLEExceptionCopyWith<$Res> {
  factory _$BLEExceptionCopyWith(
          _BLEException value, $Res Function(_BLEException) then) =
      __$BLEExceptionCopyWithImpl<$Res>;
  $Res call({BleError e});
}

/// @nodoc
class __$BLEExceptionCopyWithImpl<$Res>
    extends _$DeviceConnectionStateCopyWithImpl<$Res>
    implements _$BLEExceptionCopyWith<$Res> {
  __$BLEExceptionCopyWithImpl(
      _BLEException _value, $Res Function(_BLEException) _then)
      : super(_value, (v) => _then(v as _BLEException));

  @override
  _BLEException get _value => super._value as _BLEException;

  @override
  $Res call({
    Object e = freezed,
  }) {
    return _then(_BLEException(
      e: e == freezed ? _value.e : e as BleError,
    ));
  }
}

/// @nodoc
class _$_BLEException implements _BLEException {
  const _$_BLEException({this.e});

  @override
  final BleError e;

  @override
  String toString() {
    return 'DeviceConnectionState.bleException(e: $e)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BLEException &&
            (identical(other.e, e) ||
                const DeepCollectionEquality().equals(other.e, e)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(e);

  @JsonKey(ignore: true)
  @override
  _$BLEExceptionCopyWith<_BLEException> get copyWith =>
      __$BLEExceptionCopyWithImpl<_BLEException>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult normalBTState(PeripheralConnectionState state),
    @required TResult bleException(BleError e),
  }) {
    assert(normalBTState != null);
    assert(bleException != null);
    return bleException(e);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult normalBTState(PeripheralConnectionState state),
    TResult bleException(BleError e),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (bleException != null) {
      return bleException(e);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult normalBTState(_NormalBTState value),
    @required TResult bleException(_BLEException value),
  }) {
    assert(normalBTState != null);
    assert(bleException != null);
    return bleException(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult normalBTState(_NormalBTState value),
    TResult bleException(_BLEException value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (bleException != null) {
      return bleException(this);
    }
    return orElse();
  }
}

abstract class _BLEException implements DeviceConnectionState {
  const factory _BLEException({BleError e}) = _$_BLEException;

  BleError get e;
  @JsonKey(ignore: true)
  _$BLEExceptionCopyWith<_BLEException> get copyWith;
}

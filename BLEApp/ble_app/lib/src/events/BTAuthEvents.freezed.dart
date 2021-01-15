// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'BTAuthEvents.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$BTAuthEventTearOff {
  const _$BTAuthEventTearOff();

// ignore: unused_element
  BTAuthenticate authenticate([String pinCode]) {
    return BTAuthenticate(
      pinCode,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $BTAuthEvent = _$BTAuthEventTearOff();

/// @nodoc
mixin _$BTAuthEvent {
  String get pinCode;

  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result authenticate(String pinCode),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result authenticate(String pinCode),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result authenticate(BTAuthenticate value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result authenticate(BTAuthenticate value),
    @required Result orElse(),
  });

  $BTAuthEventCopyWith<BTAuthEvent> get copyWith;
}

/// @nodoc
abstract class $BTAuthEventCopyWith<$Res> {
  factory $BTAuthEventCopyWith(
          BTAuthEvent value, $Res Function(BTAuthEvent) then) =
      _$BTAuthEventCopyWithImpl<$Res>;
  $Res call({String pinCode});
}

/// @nodoc
class _$BTAuthEventCopyWithImpl<$Res> implements $BTAuthEventCopyWith<$Res> {
  _$BTAuthEventCopyWithImpl(this._value, this._then);

  final BTAuthEvent _value;
  // ignore: unused_field
  final $Res Function(BTAuthEvent) _then;

  @override
  $Res call({
    Object pinCode = freezed,
  }) {
    return _then(_value.copyWith(
      pinCode: pinCode == freezed ? _value.pinCode : pinCode as String,
    ));
  }
}

/// @nodoc
abstract class $BTAuthenticateCopyWith<$Res>
    implements $BTAuthEventCopyWith<$Res> {
  factory $BTAuthenticateCopyWith(
          BTAuthenticate value, $Res Function(BTAuthenticate) then) =
      _$BTAuthenticateCopyWithImpl<$Res>;
  @override
  $Res call({String pinCode});
}

/// @nodoc
class _$BTAuthenticateCopyWithImpl<$Res> extends _$BTAuthEventCopyWithImpl<$Res>
    implements $BTAuthenticateCopyWith<$Res> {
  _$BTAuthenticateCopyWithImpl(
      BTAuthenticate _value, $Res Function(BTAuthenticate) _then)
      : super(_value, (v) => _then(v as BTAuthenticate));

  @override
  BTAuthenticate get _value => super._value as BTAuthenticate;

  @override
  $Res call({
    Object pinCode = freezed,
  }) {
    return _then(BTAuthenticate(
      pinCode == freezed ? _value.pinCode : pinCode as String,
    ));
  }
}

/// @nodoc
class _$BTAuthenticate implements BTAuthenticate {
  const _$BTAuthenticate([this.pinCode]);

  @override
  final String pinCode;

  @override
  String toString() {
    return 'BTAuthEvent.authenticate(pinCode: $pinCode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is BTAuthenticate &&
            (identical(other.pinCode, pinCode) ||
                const DeepCollectionEquality().equals(other.pinCode, pinCode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(pinCode);

  @override
  $BTAuthenticateCopyWith<BTAuthenticate> get copyWith =>
      _$BTAuthenticateCopyWithImpl<BTAuthenticate>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result authenticate(String pinCode),
  }) {
    assert(authenticate != null);
    return authenticate(pinCode);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result authenticate(String pinCode),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (authenticate != null) {
      return authenticate(pinCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result authenticate(BTAuthenticate value),
  }) {
    assert(authenticate != null);
    return authenticate(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result authenticate(BTAuthenticate value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (authenticate != null) {
      return authenticate(this);
    }
    return orElse();
  }
}

abstract class BTAuthenticate implements BTAuthEvent {
  const factory BTAuthenticate([String pinCode]) = _$BTAuthenticate;

  @override
  String get pinCode;
  @override
  $BTAuthenticateCopyWith<BTAuthenticate> get copyWith;
}

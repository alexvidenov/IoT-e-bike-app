// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'authState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$AuthStateTearOff {
  const _$AuthStateTearOff();

// ignore: unused_element
  _Authenticated authenticated(String userId) {
    return _Authenticated(
      userId,
    );
  }

// ignore: unused_element
  _FailedToAuthenticate failedToAuthenticate({NotAuthenticatedReason reason}) {
    return _FailedToAuthenticate(
      reason: reason,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $AuthState = _$AuthStateTearOff();

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result authenticated(String userId),
    @required Result failedToAuthenticate(NotAuthenticatedReason reason),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result authenticated(String userId),
    Result failedToAuthenticate(NotAuthenticatedReason reason),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result authenticated(_Authenticated value),
    @required Result failedToAuthenticate(_FailedToAuthenticate value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result authenticated(_Authenticated value),
    Result failedToAuthenticate(_FailedToAuthenticate value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res> implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  final AuthState _value;
  // ignore: unused_field
  final $Res Function(AuthState) _then;
}

/// @nodoc
abstract class _$AuthenticatedCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(
          _Authenticated value, $Res Function(_Authenticated) then) =
      __$AuthenticatedCopyWithImpl<$Res>;
  $Res call({String userId});
}

/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res> extends _$AuthStateCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(
      _Authenticated _value, $Res Function(_Authenticated) _then)
      : super(_value, (v) => _then(v as _Authenticated));

  @override
  _Authenticated get _value => super._value as _Authenticated;

  @override
  $Res call({
    Object userId = freezed,
  }) {
    return _then(_Authenticated(
      userId == freezed ? _value.userId : userId as String,
    ));
  }
}

/// @nodoc
class _$_Authenticated implements _Authenticated {
  const _$_Authenticated(this.userId) : assert(userId != null);

  @override
  final String userId;

  @override
  String toString() {
    return 'AuthState.authenticated(userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Authenticated &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(userId);

  @override
  _$AuthenticatedCopyWith<_Authenticated> get copyWith =>
      __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result authenticated(String userId),
    @required Result failedToAuthenticate(NotAuthenticatedReason reason),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    return authenticated(userId);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result authenticated(String userId),
    Result failedToAuthenticate(NotAuthenticatedReason reason),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (authenticated != null) {
      return authenticated(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result authenticated(_Authenticated value),
    @required Result failedToAuthenticate(_FailedToAuthenticate value),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result authenticated(_Authenticated value),
    Result failedToAuthenticate(_FailedToAuthenticate value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class _Authenticated implements AuthState {
  const factory _Authenticated(String userId) = _$_Authenticated;

  String get userId;
  _$AuthenticatedCopyWith<_Authenticated> get copyWith;
}

/// @nodoc
abstract class _$FailedToAuthenticateCopyWith<$Res> {
  factory _$FailedToAuthenticateCopyWith(_FailedToAuthenticate value,
          $Res Function(_FailedToAuthenticate) then) =
      __$FailedToAuthenticateCopyWithImpl<$Res>;
  $Res call({NotAuthenticatedReason reason});
}

/// @nodoc
class __$FailedToAuthenticateCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res>
    implements _$FailedToAuthenticateCopyWith<$Res> {
  __$FailedToAuthenticateCopyWithImpl(
      _FailedToAuthenticate _value, $Res Function(_FailedToAuthenticate) _then)
      : super(_value, (v) => _then(v as _FailedToAuthenticate));

  @override
  _FailedToAuthenticate get _value => super._value as _FailedToAuthenticate;

  @override
  $Res call({
    Object reason = freezed,
  }) {
    return _then(_FailedToAuthenticate(
      reason:
          reason == freezed ? _value.reason : reason as NotAuthenticatedReason,
    ));
  }
}

/// @nodoc
class _$_FailedToAuthenticate implements _FailedToAuthenticate {
  const _$_FailedToAuthenticate({this.reason});

  @override
  final NotAuthenticatedReason reason;

  @override
  String toString() {
    return 'AuthState.failedToAuthenticate(reason: $reason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FailedToAuthenticate &&
            (identical(other.reason, reason) ||
                const DeepCollectionEquality().equals(other.reason, reason)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(reason);

  @override
  _$FailedToAuthenticateCopyWith<_FailedToAuthenticate> get copyWith =>
      __$FailedToAuthenticateCopyWithImpl<_FailedToAuthenticate>(
          this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result authenticated(String userId),
    @required Result failedToAuthenticate(NotAuthenticatedReason reason),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    return failedToAuthenticate(reason);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result authenticated(String userId),
    Result failedToAuthenticate(NotAuthenticatedReason reason),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (failedToAuthenticate != null) {
      return failedToAuthenticate(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result authenticated(_Authenticated value),
    @required Result failedToAuthenticate(_FailedToAuthenticate value),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    return failedToAuthenticate(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result authenticated(_Authenticated value),
    Result failedToAuthenticate(_FailedToAuthenticate value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (failedToAuthenticate != null) {
      return failedToAuthenticate(this);
    }
    return orElse();
  }
}

abstract class _FailedToAuthenticate implements AuthState {
  const factory _FailedToAuthenticate({NotAuthenticatedReason reason}) =
      _$_FailedToAuthenticate;

  NotAuthenticatedReason get reason;
  _$FailedToAuthenticateCopyWith<_FailedToAuthenticate> get copyWith;
}

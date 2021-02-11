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

// ignore: unused_element
  _FetchingUserInformation fetchingUserInformation() {
    return const _FetchingUserInformation();
  }

// ignore: unused_element
  _LoggedOut loggedOut() {
    return const _LoggedOut();
  }
}

/// @nodoc
// ignore: unused_element
const $AuthState = _$AuthStateTearOff();

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult authenticated(String userId),
    @required TResult failedToAuthenticate(NotAuthenticatedReason reason),
    @required TResult fetchingUserInformation(),
    @required TResult loggedOut(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult authenticated(String userId),
    TResult failedToAuthenticate(NotAuthenticatedReason reason),
    TResult fetchingUserInformation(),
    TResult loggedOut(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult authenticated(_Authenticated value),
    @required TResult failedToAuthenticate(_FailedToAuthenticate value),
    @required TResult fetchingUserInformation(_FetchingUserInformation value),
    @required TResult loggedOut(_LoggedOut value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult authenticated(_Authenticated value),
    TResult failedToAuthenticate(_FailedToAuthenticate value),
    TResult fetchingUserInformation(_FetchingUserInformation value),
    TResult loggedOut(_LoggedOut value),
    @required TResult orElse(),
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
  TResult when<TResult extends Object>({
    @required TResult authenticated(String userId),
    @required TResult failedToAuthenticate(NotAuthenticatedReason reason),
    @required TResult fetchingUserInformation(),
    @required TResult loggedOut(),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    assert(fetchingUserInformation != null);
    assert(loggedOut != null);
    return authenticated(userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult authenticated(String userId),
    TResult failedToAuthenticate(NotAuthenticatedReason reason),
    TResult fetchingUserInformation(),
    TResult loggedOut(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (authenticated != null) {
      return authenticated(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult authenticated(_Authenticated value),
    @required TResult failedToAuthenticate(_FailedToAuthenticate value),
    @required TResult fetchingUserInformation(_FetchingUserInformation value),
    @required TResult loggedOut(_LoggedOut value),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    assert(fetchingUserInformation != null);
    assert(loggedOut != null);
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult authenticated(_Authenticated value),
    TResult failedToAuthenticate(_FailedToAuthenticate value),
    TResult fetchingUserInformation(_FetchingUserInformation value),
    TResult loggedOut(_LoggedOut value),
    @required TResult orElse(),
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
  TResult when<TResult extends Object>({
    @required TResult authenticated(String userId),
    @required TResult failedToAuthenticate(NotAuthenticatedReason reason),
    @required TResult fetchingUserInformation(),
    @required TResult loggedOut(),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    assert(fetchingUserInformation != null);
    assert(loggedOut != null);
    return failedToAuthenticate(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult authenticated(String userId),
    TResult failedToAuthenticate(NotAuthenticatedReason reason),
    TResult fetchingUserInformation(),
    TResult loggedOut(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (failedToAuthenticate != null) {
      return failedToAuthenticate(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult authenticated(_Authenticated value),
    @required TResult failedToAuthenticate(_FailedToAuthenticate value),
    @required TResult fetchingUserInformation(_FetchingUserInformation value),
    @required TResult loggedOut(_LoggedOut value),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    assert(fetchingUserInformation != null);
    assert(loggedOut != null);
    return failedToAuthenticate(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult authenticated(_Authenticated value),
    TResult failedToAuthenticate(_FailedToAuthenticate value),
    TResult fetchingUserInformation(_FetchingUserInformation value),
    TResult loggedOut(_LoggedOut value),
    @required TResult orElse(),
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

/// @nodoc
abstract class _$FetchingUserInformationCopyWith<$Res> {
  factory _$FetchingUserInformationCopyWith(_FetchingUserInformation value,
          $Res Function(_FetchingUserInformation) then) =
      __$FetchingUserInformationCopyWithImpl<$Res>;
}

/// @nodoc
class __$FetchingUserInformationCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res>
    implements _$FetchingUserInformationCopyWith<$Res> {
  __$FetchingUserInformationCopyWithImpl(_FetchingUserInformation _value,
      $Res Function(_FetchingUserInformation) _then)
      : super(_value, (v) => _then(v as _FetchingUserInformation));

  @override
  _FetchingUserInformation get _value =>
      super._value as _FetchingUserInformation;
}

/// @nodoc
class _$_FetchingUserInformation implements _FetchingUserInformation {
  const _$_FetchingUserInformation();

  @override
  String toString() {
    return 'AuthState.fetchingUserInformation()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _FetchingUserInformation);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult authenticated(String userId),
    @required TResult failedToAuthenticate(NotAuthenticatedReason reason),
    @required TResult fetchingUserInformation(),
    @required TResult loggedOut(),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    assert(fetchingUserInformation != null);
    assert(loggedOut != null);
    return fetchingUserInformation();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult authenticated(String userId),
    TResult failedToAuthenticate(NotAuthenticatedReason reason),
    TResult fetchingUserInformation(),
    TResult loggedOut(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (fetchingUserInformation != null) {
      return fetchingUserInformation();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult authenticated(_Authenticated value),
    @required TResult failedToAuthenticate(_FailedToAuthenticate value),
    @required TResult fetchingUserInformation(_FetchingUserInformation value),
    @required TResult loggedOut(_LoggedOut value),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    assert(fetchingUserInformation != null);
    assert(loggedOut != null);
    return fetchingUserInformation(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult authenticated(_Authenticated value),
    TResult failedToAuthenticate(_FailedToAuthenticate value),
    TResult fetchingUserInformation(_FetchingUserInformation value),
    TResult loggedOut(_LoggedOut value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (fetchingUserInformation != null) {
      return fetchingUserInformation(this);
    }
    return orElse();
  }
}

abstract class _FetchingUserInformation implements AuthState {
  const factory _FetchingUserInformation() = _$_FetchingUserInformation;
}

/// @nodoc
abstract class _$LoggedOutCopyWith<$Res> {
  factory _$LoggedOutCopyWith(
          _LoggedOut value, $Res Function(_LoggedOut) then) =
      __$LoggedOutCopyWithImpl<$Res>;
}

/// @nodoc
class __$LoggedOutCopyWithImpl<$Res> extends _$AuthStateCopyWithImpl<$Res>
    implements _$LoggedOutCopyWith<$Res> {
  __$LoggedOutCopyWithImpl(_LoggedOut _value, $Res Function(_LoggedOut) _then)
      : super(_value, (v) => _then(v as _LoggedOut));

  @override
  _LoggedOut get _value => super._value as _LoggedOut;
}

/// @nodoc
class _$_LoggedOut implements _LoggedOut {
  const _$_LoggedOut();

  @override
  String toString() {
    return 'AuthState.loggedOut()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _LoggedOut);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult authenticated(String userId),
    @required TResult failedToAuthenticate(NotAuthenticatedReason reason),
    @required TResult fetchingUserInformation(),
    @required TResult loggedOut(),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    assert(fetchingUserInformation != null);
    assert(loggedOut != null);
    return loggedOut();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult authenticated(String userId),
    TResult failedToAuthenticate(NotAuthenticatedReason reason),
    TResult fetchingUserInformation(),
    TResult loggedOut(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loggedOut != null) {
      return loggedOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult authenticated(_Authenticated value),
    @required TResult failedToAuthenticate(_FailedToAuthenticate value),
    @required TResult fetchingUserInformation(_FetchingUserInformation value),
    @required TResult loggedOut(_LoggedOut value),
  }) {
    assert(authenticated != null);
    assert(failedToAuthenticate != null);
    assert(fetchingUserInformation != null);
    assert(loggedOut != null);
    return loggedOut(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult authenticated(_Authenticated value),
    TResult failedToAuthenticate(_FailedToAuthenticate value),
    TResult fetchingUserInformation(_FetchingUserInformation value),
    TResult loggedOut(_LoggedOut value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loggedOut != null) {
      return loggedOut(this);
    }
    return orElse();
  }
}

abstract class _LoggedOut implements AuthState {
  const factory _LoggedOut() = _$_LoggedOut;
}

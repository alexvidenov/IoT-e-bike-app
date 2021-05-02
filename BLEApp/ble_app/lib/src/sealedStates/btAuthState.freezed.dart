// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'btAuthState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$BTAuthStateTearOff {
  const _$BTAuthStateTearOff();

// ignore: unused_element
  _BTAuthenticated btAuthenticated() {
    return const _BTAuthenticated();
  }

// ignore: unused_element
  _BTNotAuthenticated failedToBTAuthenticate(
      {BTNotAuthenticatedReason reason}) {
    return _BTNotAuthenticated(
      reason: reason,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $BTAuthState = _$BTAuthStateTearOff();

/// @nodoc
mixin _$BTAuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult btAuthenticated(),
    @required TResult failedToBTAuthenticate(BTNotAuthenticatedReason reason),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult btAuthenticated(),
    TResult failedToBTAuthenticate(BTNotAuthenticatedReason reason),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult btAuthenticated(_BTAuthenticated value),
    @required TResult failedToBTAuthenticate(_BTNotAuthenticated value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult btAuthenticated(_BTAuthenticated value),
    TResult failedToBTAuthenticate(_BTNotAuthenticated value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $BTAuthStateCopyWith<$Res> {
  factory $BTAuthStateCopyWith(
          BTAuthState value, $Res Function(BTAuthState) then) =
      _$BTAuthStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$BTAuthStateCopyWithImpl<$Res> implements $BTAuthStateCopyWith<$Res> {
  _$BTAuthStateCopyWithImpl(this._value, this._then);

  final BTAuthState _value;
  // ignore: unused_field
  final $Res Function(BTAuthState) _then;
}

/// @nodoc
abstract class _$BTAuthenticatedCopyWith<$Res> {
  factory _$BTAuthenticatedCopyWith(
          _BTAuthenticated value, $Res Function(_BTAuthenticated) then) =
      __$BTAuthenticatedCopyWithImpl<$Res>;
}

/// @nodoc
class __$BTAuthenticatedCopyWithImpl<$Res>
    extends _$BTAuthStateCopyWithImpl<$Res>
    implements _$BTAuthenticatedCopyWith<$Res> {
  __$BTAuthenticatedCopyWithImpl(
      _BTAuthenticated _value, $Res Function(_BTAuthenticated) _then)
      : super(_value, (v) => _then(v as _BTAuthenticated));

  @override
  _BTAuthenticated get _value => super._value as _BTAuthenticated;
}

/// @nodoc
class _$_BTAuthenticated implements _BTAuthenticated {
  const _$_BTAuthenticated();

  @override
  String toString() {
    return 'BTAuthState.btAuthenticated()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _BTAuthenticated);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult btAuthenticated(),
    @required TResult failedToBTAuthenticate(BTNotAuthenticatedReason reason),
  }) {
    assert(btAuthenticated != null);
    assert(failedToBTAuthenticate != null);
    return btAuthenticated();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult btAuthenticated(),
    TResult failedToBTAuthenticate(BTNotAuthenticatedReason reason),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (btAuthenticated != null) {
      return btAuthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult btAuthenticated(_BTAuthenticated value),
    @required TResult failedToBTAuthenticate(_BTNotAuthenticated value),
  }) {
    assert(btAuthenticated != null);
    assert(failedToBTAuthenticate != null);
    return btAuthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult btAuthenticated(_BTAuthenticated value),
    TResult failedToBTAuthenticate(_BTNotAuthenticated value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (btAuthenticated != null) {
      return btAuthenticated(this);
    }
    return orElse();
  }
}

abstract class _BTAuthenticated implements BTAuthState {
  const factory _BTAuthenticated() = _$_BTAuthenticated;
}

/// @nodoc
abstract class _$BTNotAuthenticatedCopyWith<$Res> {
  factory _$BTNotAuthenticatedCopyWith(
          _BTNotAuthenticated value, $Res Function(_BTNotAuthenticated) then) =
      __$BTNotAuthenticatedCopyWithImpl<$Res>;
  $Res call({BTNotAuthenticatedReason reason});
}

/// @nodoc
class __$BTNotAuthenticatedCopyWithImpl<$Res>
    extends _$BTAuthStateCopyWithImpl<$Res>
    implements _$BTNotAuthenticatedCopyWith<$Res> {
  __$BTNotAuthenticatedCopyWithImpl(
      _BTNotAuthenticated _value, $Res Function(_BTNotAuthenticated) _then)
      : super(_value, (v) => _then(v as _BTNotAuthenticated));

  @override
  _BTNotAuthenticated get _value => super._value as _BTNotAuthenticated;

  @override
  $Res call({
    Object reason = freezed,
  }) {
    return _then(_BTNotAuthenticated(
      reason: reason == freezed
          ? _value.reason
          : reason as BTNotAuthenticatedReason,
    ));
  }
}

/// @nodoc
class _$_BTNotAuthenticated implements _BTNotAuthenticated {
  const _$_BTNotAuthenticated({this.reason});

  @override
  final BTNotAuthenticatedReason reason;

  @override
  String toString() {
    return 'BTAuthState.failedToBTAuthenticate(reason: $reason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BTNotAuthenticated &&
            (identical(other.reason, reason) ||
                const DeepCollectionEquality().equals(other.reason, reason)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(reason);

  @JsonKey(ignore: true)
  @override
  _$BTNotAuthenticatedCopyWith<_BTNotAuthenticated> get copyWith =>
      __$BTNotAuthenticatedCopyWithImpl<_BTNotAuthenticated>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult btAuthenticated(),
    @required TResult failedToBTAuthenticate(BTNotAuthenticatedReason reason),
  }) {
    assert(btAuthenticated != null);
    assert(failedToBTAuthenticate != null);
    return failedToBTAuthenticate(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult btAuthenticated(),
    TResult failedToBTAuthenticate(BTNotAuthenticatedReason reason),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (failedToBTAuthenticate != null) {
      return failedToBTAuthenticate(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult btAuthenticated(_BTAuthenticated value),
    @required TResult failedToBTAuthenticate(_BTNotAuthenticated value),
  }) {
    assert(btAuthenticated != null);
    assert(failedToBTAuthenticate != null);
    return failedToBTAuthenticate(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult btAuthenticated(_BTAuthenticated value),
    TResult failedToBTAuthenticate(_BTNotAuthenticated value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (failedToBTAuthenticate != null) {
      return failedToBTAuthenticate(this);
    }
    return orElse();
  }
}

abstract class _BTNotAuthenticated implements BTAuthState {
  const factory _BTNotAuthenticated({BTNotAuthenticatedReason reason}) =
      _$_BTNotAuthenticated;

  BTNotAuthenticatedReason get reason;
  @JsonKey(ignore: true)
  _$BTNotAuthenticatedCopyWith<_BTNotAuthenticated> get copyWith;
}

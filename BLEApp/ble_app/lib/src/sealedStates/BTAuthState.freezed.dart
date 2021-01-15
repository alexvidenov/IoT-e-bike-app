// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'BTAuthState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$BTAuthStateTearOff {
  const _$BTAuthStateTearOff();

// ignore: unused_element
  BTAuthenticated btAuthenticated() {
    return const BTAuthenticated();
  }

// ignore: unused_element
  BTNotAuthenticated notBTAuthenticated([BTNotAuthenticatedReason reason]) {
    return BTNotAuthenticated(
      reason,
    );
  }

// ignore: unused_element
  Authenticating authenticating() {
    return const Authenticating();
  }
}

/// @nodoc
// ignore: unused_element
const $BTAuthState = _$BTAuthStateTearOff();

/// @nodoc
mixin _$BTAuthState {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result btAuthenticated(),
    @required Result notBTAuthenticated(BTNotAuthenticatedReason reason),
    @required Result authenticating(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result btAuthenticated(),
    Result notBTAuthenticated(BTNotAuthenticatedReason reason),
    Result authenticating(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result btAuthenticated(BTAuthenticated value),
    @required Result notBTAuthenticated(BTNotAuthenticated value),
    @required Result authenticating(Authenticating value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result btAuthenticated(BTAuthenticated value),
    Result notBTAuthenticated(BTNotAuthenticated value),
    Result authenticating(Authenticating value),
    @required Result orElse(),
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
abstract class $BTAuthenticatedCopyWith<$Res> {
  factory $BTAuthenticatedCopyWith(
          BTAuthenticated value, $Res Function(BTAuthenticated) then) =
      _$BTAuthenticatedCopyWithImpl<$Res>;
}

/// @nodoc
class _$BTAuthenticatedCopyWithImpl<$Res>
    extends _$BTAuthStateCopyWithImpl<$Res>
    implements $BTAuthenticatedCopyWith<$Res> {
  _$BTAuthenticatedCopyWithImpl(
      BTAuthenticated _value, $Res Function(BTAuthenticated) _then)
      : super(_value, (v) => _then(v as BTAuthenticated));

  @override
  BTAuthenticated get _value => super._value as BTAuthenticated;
}

/// @nodoc
class _$BTAuthenticated implements BTAuthenticated {
  const _$BTAuthenticated();

  @override
  String toString() {
    return 'BTAuthState.btAuthenticated()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is BTAuthenticated);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result btAuthenticated(),
    @required Result notBTAuthenticated(BTNotAuthenticatedReason reason),
    @required Result authenticating(),
  }) {
    assert(btAuthenticated != null);
    assert(notBTAuthenticated != null);
    assert(authenticating != null);
    return btAuthenticated();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result btAuthenticated(),
    Result notBTAuthenticated(BTNotAuthenticatedReason reason),
    Result authenticating(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (btAuthenticated != null) {
      return btAuthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result btAuthenticated(BTAuthenticated value),
    @required Result notBTAuthenticated(BTNotAuthenticated value),
    @required Result authenticating(Authenticating value),
  }) {
    assert(btAuthenticated != null);
    assert(notBTAuthenticated != null);
    assert(authenticating != null);
    return btAuthenticated(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result btAuthenticated(BTAuthenticated value),
    Result notBTAuthenticated(BTNotAuthenticated value),
    Result authenticating(Authenticating value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (btAuthenticated != null) {
      return btAuthenticated(this);
    }
    return orElse();
  }
}

abstract class BTAuthenticated implements BTAuthState {
  const factory BTAuthenticated() = _$BTAuthenticated;
}

/// @nodoc
abstract class $BTNotAuthenticatedCopyWith<$Res> {
  factory $BTNotAuthenticatedCopyWith(
          BTNotAuthenticated value, $Res Function(BTNotAuthenticated) then) =
      _$BTNotAuthenticatedCopyWithImpl<$Res>;
  $Res call({BTNotAuthenticatedReason reason});
}

/// @nodoc
class _$BTNotAuthenticatedCopyWithImpl<$Res>
    extends _$BTAuthStateCopyWithImpl<$Res>
    implements $BTNotAuthenticatedCopyWith<$Res> {
  _$BTNotAuthenticatedCopyWithImpl(
      BTNotAuthenticated _value, $Res Function(BTNotAuthenticated) _then)
      : super(_value, (v) => _then(v as BTNotAuthenticated));

  @override
  BTNotAuthenticated get _value => super._value as BTNotAuthenticated;

  @override
  $Res call({
    Object reason = freezed,
  }) {
    return _then(BTNotAuthenticated(
      reason == freezed ? _value.reason : reason as BTNotAuthenticatedReason,
    ));
  }
}

/// @nodoc
class _$BTNotAuthenticated implements BTNotAuthenticated {
  const _$BTNotAuthenticated([this.reason]);

  @override
  final BTNotAuthenticatedReason reason;

  @override
  String toString() {
    return 'BTAuthState.notBTAuthenticated(reason: $reason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is BTNotAuthenticated &&
            (identical(other.reason, reason) ||
                const DeepCollectionEquality().equals(other.reason, reason)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(reason);

  @override
  $BTNotAuthenticatedCopyWith<BTNotAuthenticated> get copyWith =>
      _$BTNotAuthenticatedCopyWithImpl<BTNotAuthenticated>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result btAuthenticated(),
    @required Result notBTAuthenticated(BTNotAuthenticatedReason reason),
    @required Result authenticating(),
  }) {
    assert(btAuthenticated != null);
    assert(notBTAuthenticated != null);
    assert(authenticating != null);
    return notBTAuthenticated(reason);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result btAuthenticated(),
    Result notBTAuthenticated(BTNotAuthenticatedReason reason),
    Result authenticating(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (notBTAuthenticated != null) {
      return notBTAuthenticated(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result btAuthenticated(BTAuthenticated value),
    @required Result notBTAuthenticated(BTNotAuthenticated value),
    @required Result authenticating(Authenticating value),
  }) {
    assert(btAuthenticated != null);
    assert(notBTAuthenticated != null);
    assert(authenticating != null);
    return notBTAuthenticated(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result btAuthenticated(BTAuthenticated value),
    Result notBTAuthenticated(BTNotAuthenticated value),
    Result authenticating(Authenticating value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (notBTAuthenticated != null) {
      return notBTAuthenticated(this);
    }
    return orElse();
  }
}

abstract class BTNotAuthenticated implements BTAuthState {
  const factory BTNotAuthenticated([BTNotAuthenticatedReason reason]) =
      _$BTNotAuthenticated;

  BTNotAuthenticatedReason get reason;
  $BTNotAuthenticatedCopyWith<BTNotAuthenticated> get copyWith;
}

/// @nodoc
abstract class $AuthenticatingCopyWith<$Res> {
  factory $AuthenticatingCopyWith(
          Authenticating value, $Res Function(Authenticating) then) =
      _$AuthenticatingCopyWithImpl<$Res>;
}

/// @nodoc
class _$AuthenticatingCopyWithImpl<$Res> extends _$BTAuthStateCopyWithImpl<$Res>
    implements $AuthenticatingCopyWith<$Res> {
  _$AuthenticatingCopyWithImpl(
      Authenticating _value, $Res Function(Authenticating) _then)
      : super(_value, (v) => _then(v as Authenticating));

  @override
  Authenticating get _value => super._value as Authenticating;
}

/// @nodoc
class _$Authenticating implements Authenticating {
  const _$Authenticating();

  @override
  String toString() {
    return 'BTAuthState.authenticating()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Authenticating);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result btAuthenticated(),
    @required Result notBTAuthenticated(BTNotAuthenticatedReason reason),
    @required Result authenticating(),
  }) {
    assert(btAuthenticated != null);
    assert(notBTAuthenticated != null);
    assert(authenticating != null);
    return authenticating();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result btAuthenticated(),
    Result notBTAuthenticated(BTNotAuthenticatedReason reason),
    Result authenticating(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (authenticating != null) {
      return authenticating();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result btAuthenticated(BTAuthenticated value),
    @required Result notBTAuthenticated(BTNotAuthenticated value),
    @required Result authenticating(Authenticating value),
  }) {
    assert(btAuthenticated != null);
    assert(notBTAuthenticated != null);
    assert(authenticating != null);
    return authenticating(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result btAuthenticated(BTAuthenticated value),
    Result notBTAuthenticated(BTNotAuthenticated value),
    Result authenticating(Authenticating value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (authenticating != null) {
      return authenticating(this);
    }
    return orElse();
  }
}

abstract class Authenticating implements BTAuthState {
  const factory Authenticating() = _$Authenticating;
}

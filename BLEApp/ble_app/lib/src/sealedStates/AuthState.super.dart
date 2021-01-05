// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: return_of_invalid_type, constant_identifier_names, prefer_const_constructors_in_immutables, unnecessary_this, sort_unnamed_constructors_first, join_return_with_assignment, missing_return, lines_longer_than_80_chars

part of 'AuthState.dart';

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

@immutable
abstract class AuthState extends Equatable {
  const AuthState(this._type);

  factory AuthState.authenticated({@required String userId}) =
      Authenticated.create;

  factory AuthState.notAuthenticated() = NotAuthenticated.create;

  final _AuthState _type;

  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the _AuthState [_type]s defined.
  R when<R extends Object>(
      {@required R Function(Authenticated) authenticated,
      @required R Function() notAuthenticated}) {
    assert(() {
      if (authenticated == null || notAuthenticated == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _AuthState.Authenticated:
        return authenticated(this as Authenticated);
      case _AuthState.NotAuthenticated:
        return notAuthenticated();
    }
  }

  /// The [whenOrElse] method is equivalent to [when], but doesn't require
  /// all callbacks to be specified.
  ///
  /// On the other hand, it adds an extra orElse required parameter,
  /// for fallback behavior.
  R whenOrElse<R extends Object>(
      {R Function(Authenticated) authenticated,
      R Function() notAuthenticated,
      @required R Function(AuthState) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _AuthState.Authenticated:
        if (authenticated == null) break;
        return authenticated(this as Authenticated);
      case _AuthState.NotAuthenticated:
        if (notAuthenticated == null) break;
        return notAuthenticated();
    }
    return orElse(this);
  }

  /// The [whenPartial] method is equivalent to [whenOrElse],
  /// but non-exhaustive.
  void whenPartial(
      {void Function(Authenticated) authenticated,
      void Function() notAuthenticated}) {
    assert(() {
      if (authenticated == null && notAuthenticated == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _AuthState.Authenticated:
        if (authenticated == null) break;
        return authenticated(this as Authenticated);
      case _AuthState.NotAuthenticated:
        if (notAuthenticated == null) break;
        return notAuthenticated();
    }
  }

  @override
  List<Object> get props => const [];
}

@immutable
abstract class Authenticated extends AuthState {
  const Authenticated({@required this.userId})
      : super(_AuthState.Authenticated);

  factory Authenticated.create({@required String userId}) = _AuthenticatedImpl;

  final String userId;

  /// Creates a copy of this Authenticated but with the given fields
  /// replaced with the new values.
  Authenticated copyWith({String userId});
}

@immutable
class _AuthenticatedImpl extends Authenticated {
  const _AuthenticatedImpl({@required this.userId}) : super(userId: userId);

  @override
  final String userId;

  @override
  _AuthenticatedImpl copyWith({Object userId = superEnum}) =>
      _AuthenticatedImpl(
        userId: userId == superEnum ? this.userId : userId as String,
      );
  @override
  String toString() => 'Authenticated(userId: ${this.userId})';
  @override
  List<Object> get props => [userId];
}

@immutable
abstract class NotAuthenticated extends AuthState {
  const NotAuthenticated() : super(_AuthState.NotAuthenticated);

  factory NotAuthenticated.create() = _NotAuthenticatedImpl;
}

@immutable
class _NotAuthenticatedImpl extends NotAuthenticated {
  const _NotAuthenticatedImpl() : super();

  @override
  String toString() => 'NotAuthenticated()';
}

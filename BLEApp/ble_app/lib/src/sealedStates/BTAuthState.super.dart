// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: return_of_invalid_type, constant_identifier_names, prefer_const_constructors_in_immutables, unnecessary_this, sort_unnamed_constructors_first, join_return_with_assignment, missing_return, lines_longer_than_80_chars

part of 'BTAuthState.dart';

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

@immutable
abstract class BTAuthState extends Equatable {
  const BTAuthState(this._type);

  factory BTAuthState.bTAuthenticated() = BTAuthenticated.create;

  factory BTAuthState.bTNotAuthenticated(
      {@required BTNotAuthenticatedReason reason}) = BTNotAuthenticated.create;

  final _BTAuthState _type;

  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the _BTAuthState [_type]s defined.
  R when<R extends Object>(
      {@required R Function() bTAuthenticated,
      @required R Function(BTNotAuthenticated) bTNotAuthenticated}) {
    assert(() {
      if (bTAuthenticated == null || bTNotAuthenticated == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _BTAuthState.BTAuthenticated:
        return bTAuthenticated();
      case _BTAuthState.BTNotAuthenticated:
        return bTNotAuthenticated(this as BTNotAuthenticated);
    }
  }

  /// The [whenOrElse] method is equivalent to [when], but doesn't require
  /// all callbacks to be specified.
  ///
  /// On the other hand, it adds an extra orElse required parameter,
  /// for fallback behavior.
  R whenOrElse<R extends Object>(
      {R Function() bTAuthenticated,
      R Function(BTNotAuthenticated) bTNotAuthenticated,
      @required R Function(BTAuthState) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _BTAuthState.BTAuthenticated:
        if (bTAuthenticated == null) break;
        return bTAuthenticated();
      case _BTAuthState.BTNotAuthenticated:
        if (bTNotAuthenticated == null) break;
        return bTNotAuthenticated(this as BTNotAuthenticated);
    }
    return orElse(this);
  }

  /// The [whenPartial] method is equivalent to [whenOrElse],
  /// but non-exhaustive.
  void whenPartial(
      {void Function() bTAuthenticated,
      void Function(BTNotAuthenticated) bTNotAuthenticated}) {
    assert(() {
      if (bTAuthenticated == null && bTNotAuthenticated == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _BTAuthState.BTAuthenticated:
        if (bTAuthenticated == null) break;
        return bTAuthenticated();
      case _BTAuthState.BTNotAuthenticated:
        if (bTNotAuthenticated == null) break;
        return bTNotAuthenticated(this as BTNotAuthenticated);
    }
  }

  @override
  List<Object> get props => const [];
}

@immutable
abstract class BTAuthenticated extends BTAuthState {
  const BTAuthenticated() : super(_BTAuthState.BTAuthenticated);

  factory BTAuthenticated.create() = _BTAuthenticatedImpl;
}

@immutable
class _BTAuthenticatedImpl extends BTAuthenticated {
  const _BTAuthenticatedImpl() : super();

  @override
  String toString() => 'BTAuthenticated()';
}

@immutable
abstract class BTNotAuthenticated extends BTAuthState {
  const BTNotAuthenticated({@required this.reason})
      : super(_BTAuthState.BTNotAuthenticated);

  factory BTNotAuthenticated.create(
      {@required BTNotAuthenticatedReason reason}) = _BTNotAuthenticatedImpl;

  final BTNotAuthenticatedReason reason;

  /// Creates a copy of this BTNotAuthenticated but with the given fields
  /// replaced with the new values.
  BTNotAuthenticated copyWith({BTNotAuthenticatedReason reason});
}

@immutable
class _BTNotAuthenticatedImpl extends BTNotAuthenticated {
  const _BTNotAuthenticatedImpl({@required this.reason})
      : super(reason: reason);

  @override
  final BTNotAuthenticatedReason reason;

  @override
  _BTNotAuthenticatedImpl copyWith({Object reason = superEnum}) =>
      _BTNotAuthenticatedImpl(
        reason: reason == superEnum
            ? this.reason
            : reason as BTNotAuthenticatedReason,
      );
  @override
  String toString() => 'BTNotAuthenticated(reason: ${this.reason})';
  @override
  List<Object> get props => [reason];
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: return_of_invalid_type, constant_identifier_names, prefer_const_constructors_in_immutables, unnecessary_this, sort_unnamed_constructors_first, join_return_with_assignment, missing_return, lines_longer_than_80_chars

part of 'ParameterFetchState.dart';

// **************************************************************************
// SuperEnumGenerator
// **************************************************************************

@immutable
abstract class ParameterFetchState extends Equatable {
  const ParameterFetchState(this._type);

  factory ParameterFetchState.fetched(
      {@required DeviceParametersModel parameters}) = Fetched.create;

  factory ParameterFetchState.fetching() = Fetching.create;

  final _ParameterFetchState _type;

  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the _ParameterFetchState [_type]s defined.
  R when<R extends Object>(
      {@required R Function(Fetched) fetched,
      @required R Function() fetching}) {
    assert(() {
      if (fetched == null || fetching == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this._type) {
      case _ParameterFetchState.Fetched:
        return fetched(this as Fetched);
      case _ParameterFetchState.Fetching:
        return fetching();
    }
  }

  /// The [whenOrElse] method is equivalent to [when], but doesn't require
  /// all callbacks to be specified.
  ///
  /// On the other hand, it adds an extra orElse required parameter,
  /// for fallback behavior.
  R whenOrElse<R extends Object>(
      {R Function(Fetched) fetched,
      R Function() fetching,
      @required R Function(ParameterFetchState) orElse}) {
    assert(() {
      if (orElse == null) {
        throw 'Missing orElse case';
      }
      return true;
    }());
    switch (this._type) {
      case _ParameterFetchState.Fetched:
        if (fetched == null) break;
        return fetched(this as Fetched);
      case _ParameterFetchState.Fetching:
        if (fetching == null) break;
        return fetching();
    }
    return orElse(this);
  }

  /// The [whenPartial] method is equivalent to [whenOrElse],
  /// but non-exhaustive.
  void whenPartial({void Function(Fetched) fetched, void Function() fetching}) {
    assert(() {
      if (fetched == null && fetching == null) {
        throw 'provide at least one branch';
      }
      return true;
    }());
    switch (this._type) {
      case _ParameterFetchState.Fetched:
        if (fetched == null) break;
        return fetched(this as Fetched);
      case _ParameterFetchState.Fetching:
        if (fetching == null) break;
        return fetching();
    }
  }

  @override
  List<Object> get props => const [];
}

@immutable
abstract class Fetched extends ParameterFetchState {
  const Fetched({@required this.parameters})
      : super(_ParameterFetchState.Fetched);

  factory Fetched.create({@required DeviceParametersModel parameters}) =
      _FetchedImpl;

  final DeviceParametersModel parameters;

  /// Creates a copy of this Fetched but with the given fields
  /// replaced with the new values.
  Fetched copyWith({DeviceParametersModel parameters});
}

@immutable
class _FetchedImpl extends Fetched {
  const _FetchedImpl({@required this.parameters})
      : super(parameters: parameters);

  @override
  final DeviceParametersModel parameters;

  @override
  _FetchedImpl copyWith({Object parameters = superEnum}) => _FetchedImpl(
        parameters: parameters == superEnum
            ? this.parameters
            : parameters as DeviceParametersModel,
      );
  @override
  String toString() => 'Fetched(parameters: ${this.parameters})';
  @override
  List<Object> get props => [parameters];
}

@immutable
abstract class Fetching extends ParameterFetchState {
  const Fetching() : super(_ParameterFetchState.Fetching);

  factory Fetching.create() = _FetchingImpl;
}

@immutable
class _FetchingImpl extends Fetching {
  const _FetchingImpl() : super();

  @override
  String toString() => 'Fetching()';
}

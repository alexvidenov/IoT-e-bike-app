// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'shortStatusState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ShortStatusStateTearOff {
  const _$ShortStatusStateTearOff();

// ignore: unused_element
  Normal call(ShortStatusModel model) {
    return Normal(
      model,
    );
  }

// ignore: unused_element
  Error error(ErrorState errorState, [ShortStatusModel model]) {
    return Error(
      errorState,
      model,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $ShortStatusState = _$ShortStatusStateTearOff();

/// @nodoc
mixin _$ShortStatusState {
  ShortStatusModel get model;

  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(ShortStatusModel model), {
    @required Result error(ErrorState errorState, ShortStatusModel model),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(ShortStatusModel model), {
    Result error(ErrorState errorState, ShortStatusModel model),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(Normal value), {
    @required Result error(Error value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(Normal value), {
    Result error(Error value),
    @required Result orElse(),
  });

  $ShortStatusStateCopyWith<ShortStatusState> get copyWith;
}

/// @nodoc
abstract class $ShortStatusStateCopyWith<$Res> {
  factory $ShortStatusStateCopyWith(
          ShortStatusState value, $Res Function(ShortStatusState) then) =
      _$ShortStatusStateCopyWithImpl<$Res>;
  $Res call({ShortStatusModel model});
}

/// @nodoc
class _$ShortStatusStateCopyWithImpl<$Res>
    implements $ShortStatusStateCopyWith<$Res> {
  _$ShortStatusStateCopyWithImpl(this._value, this._then);

  final ShortStatusState _value;
  // ignore: unused_field
  final $Res Function(ShortStatusState) _then;

  @override
  $Res call({
    Object model = freezed,
  }) {
    return _then(_value.copyWith(
      model: model == freezed ? _value.model : model as ShortStatusModel,
    ));
  }
}

/// @nodoc
abstract class $NormalCopyWith<$Res>
    implements $ShortStatusStateCopyWith<$Res> {
  factory $NormalCopyWith(Normal value, $Res Function(Normal) then) =
      _$NormalCopyWithImpl<$Res>;
  @override
  $Res call({ShortStatusModel model});
}

/// @nodoc
class _$NormalCopyWithImpl<$Res> extends _$ShortStatusStateCopyWithImpl<$Res>
    implements $NormalCopyWith<$Res> {
  _$NormalCopyWithImpl(Normal _value, $Res Function(Normal) _then)
      : super(_value, (v) => _then(v as Normal));

  @override
  Normal get _value => super._value as Normal;

  @override
  $Res call({
    Object model = freezed,
  }) {
    return _then(Normal(
      model == freezed ? _value.model : model as ShortStatusModel,
    ));
  }
}

/// @nodoc
class _$Normal implements Normal {
  const _$Normal(this.model) : assert(model != null);

  @override
  final ShortStatusModel model;

  @override
  String toString() {
    return 'ShortStatusState(model: $model)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Normal &&
            (identical(other.model, model) ||
                const DeepCollectionEquality().equals(other.model, model)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(model);

  @override
  $NormalCopyWith<Normal> get copyWith =>
      _$NormalCopyWithImpl<Normal>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(ShortStatusModel model), {
    @required Result error(ErrorState errorState, ShortStatusModel model),
  }) {
    assert($default != null);
    assert(error != null);
    return $default(model);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(ShortStatusModel model), {
    Result error(ErrorState errorState, ShortStatusModel model),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(Normal value), {
    @required Result error(Error value),
  }) {
    assert($default != null);
    assert(error != null);
    return $default(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(Normal value), {
    Result error(Error value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class Normal implements ShortStatusState {
  const factory Normal(ShortStatusModel model) = _$Normal;

  @override
  ShortStatusModel get model;
  @override
  $NormalCopyWith<Normal> get copyWith;
}

/// @nodoc
abstract class $ErrorCopyWith<$Res> implements $ShortStatusStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) then) =
      _$ErrorCopyWithImpl<$Res>;
  @override
  $Res call({ErrorState errorState, ShortStatusModel model});
}

/// @nodoc
class _$ErrorCopyWithImpl<$Res> extends _$ShortStatusStateCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(Error _value, $Res Function(Error) _then)
      : super(_value, (v) => _then(v as Error));

  @override
  Error get _value => super._value as Error;

  @override
  $Res call({
    Object errorState = freezed,
    Object model = freezed,
  }) {
    return _then(Error(
      errorState == freezed ? _value.errorState : errorState as ErrorState,
      model == freezed ? _value.model : model as ShortStatusModel,
    ));
  }
}

/// @nodoc
class _$Error implements Error {
  const _$Error(this.errorState, [this.model]) : assert(errorState != null);

  @override
  final ErrorState errorState;
  @override
  final ShortStatusModel model;

  @override
  String toString() {
    return 'ShortStatusState.error(errorState: $errorState, model: $model)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Error &&
            (identical(other.errorState, errorState) ||
                const DeepCollectionEquality()
                    .equals(other.errorState, errorState)) &&
            (identical(other.model, model) ||
                const DeepCollectionEquality().equals(other.model, model)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(errorState) ^
      const DeepCollectionEquality().hash(model);

  @override
  $ErrorCopyWith<Error> get copyWith =>
      _$ErrorCopyWithImpl<Error>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>(
    Result $default(ShortStatusModel model), {
    @required Result error(ErrorState errorState, ShortStatusModel model),
  }) {
    assert($default != null);
    assert(error != null);
    return error(errorState, model);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>(
    Result $default(ShortStatusModel model), {
    Result error(ErrorState errorState, ShortStatusModel model),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(errorState, model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>(
    Result $default(Normal value), {
    @required Result error(Error value),
  }) {
    assert($default != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>(
    Result $default(Normal value), {
    Result error(Error value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements ShortStatusState {
  const factory Error(ErrorState errorState, [ShortStatusModel model]) =
      _$Error;

  ErrorState get errorState;
  @override
  ShortStatusModel get model;
  @override
  $ErrorCopyWith<Error> get copyWith;
}

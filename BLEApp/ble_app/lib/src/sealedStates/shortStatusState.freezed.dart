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
  ShortStatusError error(ShortStatusErrorState errorState,
      [ShortStatusModel model]) {
    return ShortStatusError(
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
  TResult when<TResult extends Object>(
    TResult $default(ShortStatusModel model), {
    @required
        TResult error(ShortStatusErrorState errorState, ShortStatusModel model),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(ShortStatusModel model), {
    TResult error(ShortStatusErrorState errorState, ShortStatusModel model),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(Normal value), {
    @required TResult error(ShortStatusError value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(Normal value), {
    TResult error(ShortStatusError value),
    @required TResult orElse(),
  });

  $ShortStatusStateCopyWith<ShortStatusState> get copyWith;
}

/// @nodoc
abstract class $ShortStatusStateCopyWith<$Res> {
  factory $ShortStatusStateCopyWith(
          ShortStatusState value, $Res Function(ShortStatusState) then) =
      _$ShortStatusStateCopyWithImpl<$Res>;
  $Res call({ShortStatusModel model});

  $ShortStatusModelCopyWith<$Res> get model;
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

  @override
  $ShortStatusModelCopyWith<$Res> get model {
    if (_value.model == null) {
      return null;
    }
    return $ShortStatusModelCopyWith<$Res>(_value.model, (value) {
      return _then(_value.copyWith(model: value));
    });
  }
}

/// @nodoc
abstract class $NormalCopyWith<$Res>
    implements $ShortStatusStateCopyWith<$Res> {
  factory $NormalCopyWith(Normal value, $Res Function(Normal) then) =
      _$NormalCopyWithImpl<$Res>;
  @override
  $Res call({ShortStatusModel model});

  @override
  $ShortStatusModelCopyWith<$Res> get model;
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
  TResult when<TResult extends Object>(
    TResult $default(ShortStatusModel model), {
    @required
        TResult error(ShortStatusErrorState errorState, ShortStatusModel model),
  }) {
    assert($default != null);
    assert(error != null);
    return $default(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(ShortStatusModel model), {
    TResult error(ShortStatusErrorState errorState, ShortStatusModel model),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if ($default != null) {
      return $default(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(Normal value), {
    @required TResult error(ShortStatusError value),
  }) {
    assert($default != null);
    assert(error != null);
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(Normal value), {
    TResult error(ShortStatusError value),
    @required TResult orElse(),
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
abstract class $ShortStatusErrorCopyWith<$Res>
    implements $ShortStatusStateCopyWith<$Res> {
  factory $ShortStatusErrorCopyWith(
          ShortStatusError value, $Res Function(ShortStatusError) then) =
      _$ShortStatusErrorCopyWithImpl<$Res>;
  @override
  $Res call({ShortStatusErrorState errorState, ShortStatusModel model});

  @override
  $ShortStatusModelCopyWith<$Res> get model;
}

/// @nodoc
class _$ShortStatusErrorCopyWithImpl<$Res>
    extends _$ShortStatusStateCopyWithImpl<$Res>
    implements $ShortStatusErrorCopyWith<$Res> {
  _$ShortStatusErrorCopyWithImpl(
      ShortStatusError _value, $Res Function(ShortStatusError) _then)
      : super(_value, (v) => _then(v as ShortStatusError));

  @override
  ShortStatusError get _value => super._value as ShortStatusError;

  @override
  $Res call({
    Object errorState = freezed,
    Object model = freezed,
  }) {
    return _then(ShortStatusError(
      errorState == freezed
          ? _value.errorState
          : errorState as ShortStatusErrorState,
      model == freezed ? _value.model : model as ShortStatusModel,
    ));
  }
}

/// @nodoc
class _$ShortStatusError implements ShortStatusError {
  const _$ShortStatusError(this.errorState, [this.model])
      : assert(errorState != null);

  @override
  final ShortStatusErrorState errorState;
  @override
  final ShortStatusModel model;

  @override
  String toString() {
    return 'ShortStatusState.error(errorState: $errorState, model: $model)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ShortStatusError &&
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
  $ShortStatusErrorCopyWith<ShortStatusError> get copyWith =>
      _$ShortStatusErrorCopyWithImpl<ShortStatusError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>(
    TResult $default(ShortStatusModel model), {
    @required
        TResult error(ShortStatusErrorState errorState, ShortStatusModel model),
  }) {
    assert($default != null);
    assert(error != null);
    return error(errorState, model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>(
    TResult $default(ShortStatusModel model), {
    TResult error(ShortStatusErrorState errorState, ShortStatusModel model),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(errorState, model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>(
    TResult $default(Normal value), {
    @required TResult error(ShortStatusError value),
  }) {
    assert($default != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>(
    TResult $default(Normal value), {
    TResult error(ShortStatusError value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ShortStatusError implements ShortStatusState {
  const factory ShortStatusError(ShortStatusErrorState errorState,
      [ShortStatusModel model]) = _$ShortStatusError;

  ShortStatusErrorState get errorState;
  @override
  ShortStatusModel get model;
  @override
  $ShortStatusErrorCopyWith<ShortStatusError> get copyWith;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'parameterFetchState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ParameterFetchStateTearOff {
  const _$ParameterFetchStateTearOff();

// ignore: unused_element
  _Fetched fetched(DeviceParameters model) {
    return _Fetched(
      model,
    );
  }

// ignore: unused_element
  _Fetching fetching() {
    return const _Fetching();
  }
}

/// @nodoc
// ignore: unused_element
const $ParameterFetchState = _$ParameterFetchStateTearOff();

/// @nodoc
mixin _$ParameterFetchState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult fetched(DeviceParameters model),
    @required TResult fetching(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult fetched(DeviceParameters model),
    TResult fetching(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult fetched(_Fetched value),
    @required TResult fetching(_Fetching value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult fetched(_Fetched value),
    TResult fetching(_Fetching value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $ParameterFetchStateCopyWith<$Res> {
  factory $ParameterFetchStateCopyWith(
          ParameterFetchState value, $Res Function(ParameterFetchState) then) =
      _$ParameterFetchStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$ParameterFetchStateCopyWithImpl<$Res>
    implements $ParameterFetchStateCopyWith<$Res> {
  _$ParameterFetchStateCopyWithImpl(this._value, this._then);

  final ParameterFetchState _value;
  // ignore: unused_field
  final $Res Function(ParameterFetchState) _then;
}

/// @nodoc
abstract class _$FetchedCopyWith<$Res> {
  factory _$FetchedCopyWith(_Fetched value, $Res Function(_Fetched) then) =
      __$FetchedCopyWithImpl<$Res>;
  $Res call({DeviceParameters model});
}

/// @nodoc
class __$FetchedCopyWithImpl<$Res>
    extends _$ParameterFetchStateCopyWithImpl<$Res>
    implements _$FetchedCopyWith<$Res> {
  __$FetchedCopyWithImpl(_Fetched _value, $Res Function(_Fetched) _then)
      : super(_value, (v) => _then(v as _Fetched));

  @override
  _Fetched get _value => super._value as _Fetched;

  @override
  $Res call({
    Object model = freezed,
  }) {
    return _then(_Fetched(
      model == freezed ? _value.model : model as DeviceParameters,
    ));
  }
}

/// @nodoc
class _$_Fetched implements _Fetched {
  const _$_Fetched(this.model) : assert(model != null);

  @override
  final DeviceParameters model;

  @override
  String toString() {
    return 'ParameterFetchState.fetched(model: $model)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Fetched &&
            (identical(other.model, model) ||
                const DeepCollectionEquality().equals(other.model, model)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(model);

  @JsonKey(ignore: true)
  @override
  _$FetchedCopyWith<_Fetched> get copyWith =>
      __$FetchedCopyWithImpl<_Fetched>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult fetched(DeviceParameters model),
    @required TResult fetching(),
  }) {
    assert(fetched != null);
    assert(fetching != null);
    return fetched(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult fetched(DeviceParameters model),
    TResult fetching(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (fetched != null) {
      return fetched(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult fetched(_Fetched value),
    @required TResult fetching(_Fetching value),
  }) {
    assert(fetched != null);
    assert(fetching != null);
    return fetched(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult fetched(_Fetched value),
    TResult fetching(_Fetching value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (fetched != null) {
      return fetched(this);
    }
    return orElse();
  }
}

abstract class _Fetched implements ParameterFetchState {
  const factory _Fetched(DeviceParameters model) = _$_Fetched;

  DeviceParameters get model;
  @JsonKey(ignore: true)
  _$FetchedCopyWith<_Fetched> get copyWith;
}

/// @nodoc
abstract class _$FetchingCopyWith<$Res> {
  factory _$FetchingCopyWith(_Fetching value, $Res Function(_Fetching) then) =
      __$FetchingCopyWithImpl<$Res>;
}

/// @nodoc
class __$FetchingCopyWithImpl<$Res>
    extends _$ParameterFetchStateCopyWithImpl<$Res>
    implements _$FetchingCopyWith<$Res> {
  __$FetchingCopyWithImpl(_Fetching _value, $Res Function(_Fetching) _then)
      : super(_value, (v) => _then(v as _Fetching));

  @override
  _Fetching get _value => super._value as _Fetching;
}

/// @nodoc
class _$_Fetching implements _Fetching {
  const _$_Fetching();

  @override
  String toString() {
    return 'ParameterFetchState.fetching()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Fetching);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult fetched(DeviceParameters model),
    @required TResult fetching(),
  }) {
    assert(fetched != null);
    assert(fetching != null);
    return fetching();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult fetched(DeviceParameters model),
    TResult fetching(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (fetching != null) {
      return fetching();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult fetched(_Fetched value),
    @required TResult fetching(_Fetching value),
  }) {
    assert(fetched != null);
    assert(fetching != null);
    return fetching(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult fetched(_Fetched value),
    TResult fetching(_Fetching value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (fetching != null) {
      return fetching(this);
    }
    return orElse();
  }
}

abstract class _Fetching implements ParameterFetchState {
  const factory _Fetching() = _$_Fetching;
}

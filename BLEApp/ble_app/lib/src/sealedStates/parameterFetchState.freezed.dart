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
  _Fetched fetched(DeviceParametersModel model) {
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
  Result when<Result extends Object>({
    @required Result fetched(DeviceParametersModel model),
    @required Result fetching(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result fetched(DeviceParametersModel model),
    Result fetching(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result fetched(_Fetched value),
    @required Result fetching(_Fetching value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result fetched(_Fetched value),
    Result fetching(_Fetching value),
    @required Result orElse(),
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
  $Res call({DeviceParametersModel model});
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
      model == freezed ? _value.model : model as DeviceParametersModel,
    ));
  }
}

/// @nodoc
class _$_Fetched implements _Fetched {
  const _$_Fetched(this.model) : assert(model != null);

  @override
  final DeviceParametersModel model;

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

  @override
  _$FetchedCopyWith<_Fetched> get copyWith =>
      __$FetchedCopyWithImpl<_Fetched>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result fetched(DeviceParametersModel model),
    @required Result fetching(),
  }) {
    assert(fetched != null);
    assert(fetching != null);
    return fetched(model);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result fetched(DeviceParametersModel model),
    Result fetching(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (fetched != null) {
      return fetched(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result fetched(_Fetched value),
    @required Result fetching(_Fetching value),
  }) {
    assert(fetched != null);
    assert(fetching != null);
    return fetched(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result fetched(_Fetched value),
    Result fetching(_Fetching value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (fetched != null) {
      return fetched(this);
    }
    return orElse();
  }
}

abstract class _Fetched implements ParameterFetchState {
  const factory _Fetched(DeviceParametersModel model) = _$_Fetched;

  DeviceParametersModel get model;
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
  Result when<Result extends Object>({
    @required Result fetched(DeviceParametersModel model),
    @required Result fetching(),
  }) {
    assert(fetched != null);
    assert(fetching != null);
    return fetching();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result fetched(DeviceParametersModel model),
    Result fetching(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (fetching != null) {
      return fetching();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result fetched(_Fetched value),
    @required Result fetching(_Fetching value),
  }) {
    assert(fetched != null);
    assert(fetching != null);
    return fetching(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result fetched(_Fetched value),
    Result fetching(_Fetching value),
    @required Result orElse(),
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

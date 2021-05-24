// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'fullStatusBarGraphModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$FullStatusDataModelTearOff {
  const _$FullStatusDataModelTearOff();

// ignore: unused_element
  _FullStatusDataModel call({int x, double y, Color color}) {
    return _FullStatusDataModel(
      x: x,
      y: y,
      color: color,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $FullStatusDataModel = _$FullStatusDataModelTearOff();

/// @nodoc
mixin _$FullStatusDataModel {
  int get x;
  double get y;
  Color get color;

  @JsonKey(ignore: true)
  $FullStatusDataModelCopyWith<FullStatusDataModel> get copyWith;
}

/// @nodoc
abstract class $FullStatusDataModelCopyWith<$Res> {
  factory $FullStatusDataModelCopyWith(
          FullStatusDataModel value, $Res Function(FullStatusDataModel) then) =
      _$FullStatusDataModelCopyWithImpl<$Res>;
  $Res call({int x, double y, Color color});
}

/// @nodoc
class _$FullStatusDataModelCopyWithImpl<$Res>
    implements $FullStatusDataModelCopyWith<$Res> {
  _$FullStatusDataModelCopyWithImpl(this._value, this._then);

  final FullStatusDataModel _value;
  // ignore: unused_field
  final $Res Function(FullStatusDataModel) _then;

  @override
  $Res call({
    Object x = freezed,
    Object y = freezed,
    Object color = freezed,
  }) {
    return _then(_value.copyWith(
      x: x == freezed ? _value.x : x as int,
      y: y == freezed ? _value.y : y as double,
      color: color == freezed ? _value.color : color as Color,
    ));
  }
}

/// @nodoc
abstract class _$FullStatusDataModelCopyWith<$Res>
    implements $FullStatusDataModelCopyWith<$Res> {
  factory _$FullStatusDataModelCopyWith(_FullStatusDataModel value,
          $Res Function(_FullStatusDataModel) then) =
      __$FullStatusDataModelCopyWithImpl<$Res>;
  @override
  $Res call({int x, double y, Color color});
}

/// @nodoc
class __$FullStatusDataModelCopyWithImpl<$Res>
    extends _$FullStatusDataModelCopyWithImpl<$Res>
    implements _$FullStatusDataModelCopyWith<$Res> {
  __$FullStatusDataModelCopyWithImpl(
      _FullStatusDataModel _value, $Res Function(_FullStatusDataModel) _then)
      : super(_value, (v) => _then(v as _FullStatusDataModel));

  @override
  _FullStatusDataModel get _value => super._value as _FullStatusDataModel;

  @override
  $Res call({
    Object x = freezed,
    Object y = freezed,
    Object color = freezed,
  }) {
    return _then(_FullStatusDataModel(
      x: x == freezed ? _value.x : x as int,
      y: y == freezed ? _value.y : y as double,
      color: color == freezed ? _value.color : color as Color,
    ));
  }
}

/// @nodoc
class _$_FullStatusDataModel implements _FullStatusDataModel {
  const _$_FullStatusDataModel({this.x, this.y, this.color});

  @override
  final int x;
  @override
  final double y;
  @override
  final Color color;

  @override
  String toString() {
    return 'FullStatusDataModel(x: $x, y: $y, color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FullStatusDataModel &&
            (identical(other.x, x) ||
                const DeepCollectionEquality().equals(other.x, x)) &&
            (identical(other.y, y) ||
                const DeepCollectionEquality().equals(other.y, y)) &&
            (identical(other.color, color) ||
                const DeepCollectionEquality().equals(other.color, color)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(x) ^
      const DeepCollectionEquality().hash(y) ^
      const DeepCollectionEquality().hash(color);

  @JsonKey(ignore: true)
  @override
  _$FullStatusDataModelCopyWith<_FullStatusDataModel> get copyWith =>
      __$FullStatusDataModelCopyWithImpl<_FullStatusDataModel>(
          this, _$identity);
}

abstract class _FullStatusDataModel implements FullStatusDataModel {
  const factory _FullStatusDataModel({int x, double y, Color color}) =
      _$_FullStatusDataModel;

  @override
  int get x;
  @override
  double get y;
  @override
  Color get color;
  @override
  @JsonKey(ignore: true)
  _$FullStatusDataModelCopyWith<_FullStatusDataModel> get copyWith;
}

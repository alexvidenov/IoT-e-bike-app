// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'routeFileModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
RouteFileModel _$RouteFileModelFromJson(Map<String, dynamic> json) {
  return RouteModel.fromJson(json);
}

/// @nodoc
class _$RouteFileModelTearOff {
  const _$RouteFileModelTearOff();

// ignore: unused_element
  RouteModel call(
      {String name,
      String startedAt,
      String finishedAt,
      double length,
      double consumed,
      @LatLngConverter() List<LatLng> coordinates}) {
    return RouteModel(
      name: name,
      startedAt: startedAt,
      finishedAt: finishedAt,
      length: length,
      consumed: consumed,
      coordinates: coordinates,
    );
  }

// ignore: unused_element
  RouteFileModel fromJson(Map<String, Object> json) {
    return RouteFileModel.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $RouteFileModel = _$RouteFileModelTearOff();

/// @nodoc
mixin _$RouteFileModel {
  String get name;
  String get startedAt;
  String get finishedAt;
  double get length;
  double get consumed;
  @LatLngConverter()
  List<LatLng> get coordinates;

  Map<String, dynamic> toJson();
  @JsonKey(ignore: true)
  $RouteFileModelCopyWith<RouteFileModel> get copyWith;
}

/// @nodoc
abstract class $RouteFileModelCopyWith<$Res> {
  factory $RouteFileModelCopyWith(
          RouteFileModel value, $Res Function(RouteFileModel) then) =
      _$RouteFileModelCopyWithImpl<$Res>;
  $Res call(
      {String name,
      String startedAt,
      String finishedAt,
      double length,
      double consumed,
      @LatLngConverter() List<LatLng> coordinates});
}

/// @nodoc
class _$RouteFileModelCopyWithImpl<$Res>
    implements $RouteFileModelCopyWith<$Res> {
  _$RouteFileModelCopyWithImpl(this._value, this._then);

  final RouteFileModel _value;
  // ignore: unused_field
  final $Res Function(RouteFileModel) _then;

  @override
  $Res call({
    Object name = freezed,
    Object startedAt = freezed,
    Object finishedAt = freezed,
    Object length = freezed,
    Object consumed = freezed,
    Object coordinates = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      startedAt: startedAt == freezed ? _value.startedAt : startedAt as String,
      finishedAt:
          finishedAt == freezed ? _value.finishedAt : finishedAt as String,
      length: length == freezed ? _value.length : length as double,
      consumed: consumed == freezed ? _value.consumed : consumed as double,
      coordinates: coordinates == freezed
          ? _value.coordinates
          : coordinates as List<LatLng>,
    ));
  }
}

/// @nodoc
abstract class $RouteModelCopyWith<$Res>
    implements $RouteFileModelCopyWith<$Res> {
  factory $RouteModelCopyWith(
          RouteModel value, $Res Function(RouteModel) then) =
      _$RouteModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      String startedAt,
      String finishedAt,
      double length,
      double consumed,
      @LatLngConverter() List<LatLng> coordinates});
}

/// @nodoc
class _$RouteModelCopyWithImpl<$Res> extends _$RouteFileModelCopyWithImpl<$Res>
    implements $RouteModelCopyWith<$Res> {
  _$RouteModelCopyWithImpl(RouteModel _value, $Res Function(RouteModel) _then)
      : super(_value, (v) => _then(v as RouteModel));

  @override
  RouteModel get _value => super._value as RouteModel;

  @override
  $Res call({
    Object name = freezed,
    Object startedAt = freezed,
    Object finishedAt = freezed,
    Object length = freezed,
    Object consumed = freezed,
    Object coordinates = freezed,
  }) {
    return _then(RouteModel(
      name: name == freezed ? _value.name : name as String,
      startedAt: startedAt == freezed ? _value.startedAt : startedAt as String,
      finishedAt:
          finishedAt == freezed ? _value.finishedAt : finishedAt as String,
      length: length == freezed ? _value.length : length as double,
      consumed: consumed == freezed ? _value.consumed : consumed as double,
      coordinates: coordinates == freezed
          ? _value.coordinates
          : coordinates as List<LatLng>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$RouteModel implements RouteModel {
  const _$RouteModel(
      {this.name,
      this.startedAt,
      this.finishedAt,
      this.length,
      this.consumed,
      @LatLngConverter() this.coordinates});

  factory _$RouteModel.fromJson(Map<String, dynamic> json) =>
      _$_$RouteModelFromJson(json);

  @override
  final String name;
  @override
  final String startedAt;
  @override
  final String finishedAt;
  @override
  final double length;
  @override
  final double consumed;
  @override
  @LatLngConverter()
  final List<LatLng> coordinates;

  @override
  String toString() {
    return 'RouteFileModel(name: $name, startedAt: $startedAt, finishedAt: $finishedAt, length: $length, consumed: $consumed, coordinates: $coordinates)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is RouteModel &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.startedAt, startedAt) ||
                const DeepCollectionEquality()
                    .equals(other.startedAt, startedAt)) &&
            (identical(other.finishedAt, finishedAt) ||
                const DeepCollectionEquality()
                    .equals(other.finishedAt, finishedAt)) &&
            (identical(other.length, length) ||
                const DeepCollectionEquality().equals(other.length, length)) &&
            (identical(other.consumed, consumed) ||
                const DeepCollectionEquality()
                    .equals(other.consumed, consumed)) &&
            (identical(other.coordinates, coordinates) ||
                const DeepCollectionEquality()
                    .equals(other.coordinates, coordinates)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(startedAt) ^
      const DeepCollectionEquality().hash(finishedAt) ^
      const DeepCollectionEquality().hash(length) ^
      const DeepCollectionEquality().hash(consumed) ^
      const DeepCollectionEquality().hash(coordinates);

  @JsonKey(ignore: true)
  @override
  $RouteModelCopyWith<RouteModel> get copyWith =>
      _$RouteModelCopyWithImpl<RouteModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$RouteModelToJson(this);
  }
}

abstract class RouteModel implements RouteFileModel {
  const factory RouteModel(
      {String name,
      String startedAt,
      String finishedAt,
      double length,
      double consumed,
      @LatLngConverter() List<LatLng> coordinates}) = _$RouteModel;

  factory RouteModel.fromJson(Map<String, dynamic> json) =
      _$RouteModel.fromJson;

  @override
  String get name;
  @override
  String get startedAt;
  @override
  String get finishedAt;
  @override
  double get length;
  @override
  double get consumed;
  @override
  @LatLngConverter()
  List<LatLng> get coordinates;
  @override
  @JsonKey(ignore: true)
  $RouteModelCopyWith<RouteModel> get copyWith;
}

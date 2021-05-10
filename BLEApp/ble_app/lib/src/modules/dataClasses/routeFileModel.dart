import 'package:ble_app/src/modules/converters/LatLngConverter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'routeFileModel.freezed.dart';

part 'routeFileModel.g.dart';

@freezed
abstract class RouteFileModel with _$RouteFileModel {
  const factory RouteFileModel({
    final String name,
    final String startedAt,
    final String finishedAt,
    final double length,
    final double consumed,
    @LatLngConverter() final List<LatLng> coordinates,
  }) = RouteModel;

  factory RouteFileModel.fromJson(Map<String, dynamic> json) =>
      _$RouteFileModelFromJson(json);
}

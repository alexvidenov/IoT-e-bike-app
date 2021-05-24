import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LatLngConverter implements JsonConverter<LatLng, Map<String, dynamic>> {
  const LatLngConverter();

  @override
  LatLng fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return LatLng.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(LatLng coords) => coords.toJson();
}

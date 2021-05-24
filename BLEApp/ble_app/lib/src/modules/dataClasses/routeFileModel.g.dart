// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routeFileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RouteModel _$_$RouteModelFromJson(Map<String, dynamic> json) {
  return _$RouteModel(
    name: json['name'] as String,
    startedAt: json['startedAt'] as String,
    finishedAt: json['finishedAt'] as String,
    length: (json['length'] as num)?.toDouble(),
    consumed: (json['consumed'] as num)?.toDouble(),
    coordinates: (json['coordinates'] as List)
        ?.map(
            (e) => const LatLngConverter().fromJson(e))
        ?.toList(),
  );
}

Map<String, dynamic> _$_$RouteModelToJson(_$RouteModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'startedAt': instance.startedAt,
      'finishedAt': instance.finishedAt,
      'length': instance.length,
      'consumed': instance.consumed,
      'coordinates':
          instance.coordinates?.map(const LatLngConverter().toJson)?.toList(),
    };

import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MathUtil {
  static num toRadians(num degrees) => degrees / 180.0 * pi;

  static num hav(num x) => sin(x * 0.5) * sin(x * 0.5);

  static num arcHav(num x) => 2 * asin(sqrt(x));

  static num havDistance(num lat1, num lat2, num dLng) =>
      hav(lat1 - lat2) + hav(dLng) * cos(lat1) * cos(lat2);
}

class SphericalUtil {
  static const num earthRadius = 6371009.0;

  static num computeLength(List<LatLng> path) {
    if (path.length < 2) {
      return 0;
    }

    final prev = path.first;
    var prevLat = MathUtil.toRadians(prev.latitude);
    var prevLng = MathUtil.toRadians(prev.longitude);

    final length = path.fold<num>(0.0, (value, point) {
      final lat = MathUtil.toRadians(point.latitude);
      final lng = MathUtil.toRadians(point.longitude);
      value += distanceRadians(prevLat, prevLng, lat, lng);
      prevLat = lat;
      prevLng = lng;

      return value;
    });

    return length * earthRadius;
  }

  static num distanceRadians(num lat1, num lng1, num lat2, num lng2) =>
      MathUtil.arcHav(MathUtil.havDistance(lat1, lat2, lng1 - lng2));
}

import 'dart:math' as math;

import '../entities/location_coordinate.dart';

class GetQiblahBearing {
  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  double call(LocationCoordinate coordinate) {
    final latRad = _degToRad(coordinate.latitude);
    final lngRad = _degToRad(coordinate.longitude);
    final kaabaLat = _degToRad(_kaabaLat);
    final kaabaLng = _degToRad(_kaabaLng);

    final deltaLng = kaabaLng - lngRad;
    final y = math.sin(deltaLng);
    final x = math.cos(latRad) * math.tan(kaabaLat) -
        math.sin(latRad) * math.cos(deltaLng);
    final bearing = math.atan2(y, x);
    return (_radToDeg(bearing) + 360) % 360;
  }

  double _degToRad(double value) => value * math.pi / 180;
  double _radToDeg(double value) => value * 180 / math.pi;
}

import 'package:flutter_test/flutter_test.dart';

import 'package:azkar/core/domain/entities/location_coordinate.dart';
import 'package:azkar/core/domain/usecases/get_qiblah_bearing.dart';

void main() {
  final useCase = GetQiblahBearing();

  group('GetQiblahBearing', () {
    test('returns 0\\u00B0 when already at the Kaaba', () {
      const coordinate = LocationCoordinate(latitude: 21.4225, longitude: 39.8262);

      final result = useCase(coordinate);

      expect(result, equals(0));
    });

    test('computes expected bearing for New York City', () {
      const coordinate = LocationCoordinate(latitude: 40.7128, longitude: -74.0060);

      final result = useCase(coordinate);

      expect(result, closeTo(58.5, 0.5));
    });

    test('computes expected bearing for Sydney', () {
      const coordinate = LocationCoordinate(latitude: -33.8688, longitude: 151.2093);

      final result = useCase(coordinate);

      expect(result, closeTo(277.5, 0.5));
    });
  });
}

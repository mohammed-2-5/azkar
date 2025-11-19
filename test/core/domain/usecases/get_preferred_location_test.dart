import 'package:azkar/core/domain/usecases/get_preferred_location.dart';
import 'package:azkar/core/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late _FakeLocationService locationService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    locationService = _FakeLocationService();
  });

  GetPreferredLocation buildUseCase() => GetPreferredLocation(locationService);

  test('returns fixed coordinates when set in preferences', () async {
    SharedPreferences.setMockInitialValues({
      'fixed_lat': 10.0,
      'fixed_lng': 20.0,
      'fixed_label': 'Makkah',
    });

    final useCase = buildUseCase();
    final result = await useCase();

    expect(result, isNotNull);
    expect(result!.usesDeviceLocation, isFalse);
    expect(result.coordinate.latitude, 10.0);
    expect(result.coordinate.longitude, 20.0);
    expect(result.label, 'Makkah');
  });

  test('falls back to device location when no fixed values exist', () async {
    locationService.position = _position(lat: 30.0, lng: 40.0);
    final useCase = buildUseCase();

    final result = await useCase();

    expect(result, isNotNull);
    expect(result!.usesDeviceLocation, isTrue);
    expect(result.coordinate.latitude, 30.0);
    expect(result.coordinate.longitude, 40.0);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getDouble('last_lat'), 30.0);
    expect(prefs.getDouble('last_lng'), 40.0);
    expect(prefs.getInt('last_ts'), isNotNull);
  });

  test('returns cached coordinates when device location fails', () async {
    SharedPreferences.setMockInitialValues({
      'last_lat': 5.0,
      'last_lng': 6.0,
      'last_label': 'Fallback City',
      'last_ts': DateTime(2024, 1, 1).millisecondsSinceEpoch,
    });
    locationService.error = Exception('location disabled');
    final useCase = buildUseCase();

    final result = await useCase();

    expect(result, isNotNull);
    expect(result!.usesDeviceLocation, isFalse);
    expect(result.coordinate.latitude, 5.0);
    expect(result.coordinate.longitude, 6.0);
    expect(result.label, 'Fallback City');
  });

  test('returns null when no sources are available', () async {
    locationService.error = Exception('location disabled');
    final useCase = buildUseCase();

    final result = await useCase();

    expect(result, isNull);
  });
}

Position _position({required double lat, required double lng}) {
  return Position(
    latitude: lat,
    longitude: lng,
    timestamp: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    accuracy: 0,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

class _FakeLocationService extends LocationService {
  Position? position;
  Object? error;

  @override
  Future<Position> getCurrentPosition() async {
    if (error != null) {
      throw error!;
    }
    if (position == null) {
      throw Exception('No fake position provided');
    }
    return position!;
  }

  @override
  Future<bool> ensurePermission() async => true;
}

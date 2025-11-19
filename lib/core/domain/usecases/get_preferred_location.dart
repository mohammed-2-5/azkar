import 'package:shared_preferences/shared_preferences.dart';

import '../../services/location_service.dart';
import '../entities/location_coordinate.dart';
import '../entities/resolved_location.dart';

typedef SharedPreferencesLoader = Future<SharedPreferences> Function();

class GetPreferredLocation {
  GetPreferredLocation(
    this._locationService, {
    SharedPreferencesLoader? prefsLoader,
  }) : _prefsLoader = prefsLoader ?? SharedPreferences.getInstance;

  final LocationService _locationService;
  final SharedPreferencesLoader _prefsLoader;

  Future<ResolvedLocation?> call() async {
    final prefs = await _prefsLoader();

    final fixed = _readCoordinate(
      prefs,
      latKey: 'fixed_lat',
      lngKey: 'fixed_lng',
      timestampKey: 'fixed_ts',
    );
    if (fixed != null) {
      return ResolvedLocation(
        coordinate: fixed.$1,
        source: PreferredLocationSource.fixed,
        label: prefs.getString('fixed_label'),
        timestamp: fixed.$2,
      );
    }

    try {
      final position = await _locationService.getCurrentPosition();
      final coordinate = LocationCoordinate(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      final now = DateTime.now();
      await prefs.setDouble('last_lat', coordinate.latitude);
      await prefs.setDouble('last_lng', coordinate.longitude);
      await prefs.setInt('last_ts', now.millisecondsSinceEpoch);
      return ResolvedLocation(
        coordinate: coordinate,
        source: PreferredLocationSource.device,
        timestamp: now,
      );
    } catch (_) {
      final fallback = _readCoordinate(
        prefs,
        latKey: 'last_lat',
        lngKey: 'last_lng',
        timestampKey: 'last_ts',
      );
      if (fallback != null) {
        return ResolvedLocation(
          coordinate: fallback.$1,
          source: PreferredLocationSource.cached,
          label: prefs.getString('last_label'),
          timestamp: fallback.$2,
        );
      }
      return null;
    }
  }

  (LocationCoordinate, DateTime?)? _readCoordinate(
    SharedPreferences prefs, {
    required String latKey,
    required String lngKey,
    required String timestampKey,
  }) {
    final lat = prefs.getDouble(latKey);
    final lng = prefs.getDouble(lngKey);
    if (lat == null || lng == null) return null;
    final millis = prefs.getInt(timestampKey);
    final timestamp = millis != null
        ? DateTime.fromMillisecondsSinceEpoch(millis)
        : null;
    return (
      LocationCoordinate(latitude: lat, longitude: lng),
      timestamp,
    );
  }
}

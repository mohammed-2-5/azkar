import 'package:azkar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/telemetry/telemetry_service.dart';
import 'app.dart';

class PermissionGate extends StatefulWidget {
  const PermissionGate({super.key, required this.dep});
  final AppDependencies dep;

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> {
  bool _checking = true;
  bool _granted = false;
  bool _locating = false;
  Position? _position;
  String? _error;
  bool _skipGate = false;
  TelemetryService get _telemetry => widget.dep.telemetryService;

  @override
  void initState() {
    super.initState();
    _initFlow();
  }

  Future<void> _initFlow() async {
    final sp = await SharedPreferences.getInstance();
    final onboarded = sp.getBool('location_onboarded') ?? false;
    if (onboarded) {
      setState(() {
        _skipGate = true;
      });
      _telemetry.logEvent('location_gate_skipped');
    } else {
      _check();
    }
  }

  Future<void> _check() async {
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      final ok = await widget.dep.locationService.ensurePermission();
      _granted = ok;
      _checking = false;
      _telemetry.logEvent('location_permission_status', {
        'granted': ok,
        'auto': true,
      });
      if (ok) {
        await _obtainLocation();
      }
      setState(() {});
    } catch (e, stack) {
      setState(() {
        _error = e.toString();
        _granted = false;
        _checking = false;
      });
      _telemetry.logError(e, stack, context: 'location_permission_check');
    }
  }

  Future<void> _request() async {
    setState(() => _checking = true);
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      final ok =
          perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse;
      _granted = ok;
      _checking = false;
      _telemetry.logEvent('location_permission_status', {
        'granted': ok,
        'auto': false,
      });
      if (ok) {
        await _obtainLocation();
      }
      setState(() {});
    } catch (e, stack) {
      setState(() {
        _error = e.toString();
        _granted = false;
        _checking = false;
      });
      _telemetry.logError(e, stack, context: 'location_permission_request');
    }
  }

  Future<void> _obtainLocation() async {
    setState(() {
      _locating = true;
      _error = null;
    });
    _telemetry.logEvent('location_acquire_start');
    try {
      // Try current position with a timeout; fall back to last known.
      Position pos;
      try {
        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 8));
      } catch (_) {
        final last = await Geolocator.getLastKnownPosition();
        if (last == null) rethrow;
        pos = last;
        _telemetry.logEvent('location_use_last_known');
      }
      setState(() {
        _position = pos;
        _locating = false;
      });
      final sp = await SharedPreferences.getInstance();
      await sp.setBool('location_onboarded', true);
      _telemetry.logEvent('location_acquired', {
        'lat': pos.latitude,
        'lng': pos.longitude,
        'accuracy': pos.accuracy,
      });
    } catch (e) {
      final l10n = _safeLocalizations();
      setState(() {
        _error =
            l10n?.permissionLocationError ??
            'Unable to acquire location. Ensure GPS is ON and try again.';
        _position = null;
        _locating = false;
      });
      _telemetry.logError(e, StackTrace.current, context: 'location_acquire');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_skipGate) {
      return App(dep: widget.dep);
    }
    if (_checking) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    if (_granted && _position != null) {
      return App(dep: widget.dep);
    }
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const Icon(Icons.my_location, size: 72),
                    const SizedBox(height: 16),
                    Text(
                      l10n.permissionTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _granted
                          ? (_locating
                                ? l10n.permissionAcquiring
                                : l10n.permissionGps)
                          : l10n.permissionWhy,
                      textAlign: TextAlign.center,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (!_granted)
                      FilledButton(
                        onPressed: _request,
                        child: Text(l10n.permissionGrant),
                      ),
                    if (_granted && !_locating)
                      FilledButton.icon(
                        onPressed: _obtainLocation,
                        icon: const Icon(Icons.my_location),
                        label: Text(l10n.permissionGetLocation),
                      ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () async {
                        await Geolocator.openAppSettings();
                        await Geolocator.openLocationSettings();
                        _telemetry.logEvent('location_open_settings');
                        if (context.mounted) _check();
                      },
                      child: Text(l10n.permissionOpenSettings),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _check,
                      child: Text(l10n.permissionRetry),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppLocalizations? _safeLocalizations() {
    try {
      return AppLocalizations.of(context);
    } catch (_) {
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      try {
        return lookupAppLocalizations(locale);
      } catch (_) {
        return null;
      }
    }
  }
}

import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelemetryService {
  TelemetryService();

  static const _prefsKey = 'telemetry_enabled';
  static const _logPrefsKey = 'telemetry_log';

  bool _enabled = false;
  SharedPreferences? _prefs;
  final List<TelemetryEntry> _log = [];
  static const int _maxEntries = 50;

  bool get enabled => _enabled;
  List<TelemetryEntry> get entries => List.unmodifiable(_log);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _enabled = _prefs?.getBool(_prefsKey) ?? false;
    _restoreLog();
    _attachErrorHandlers();
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    await _prefs?.setBool(_prefsKey, value);
  }

  void logEvent(String name, [Map<String, dynamic>? params]) {
    if (!_enabled) return;
    _addEntry(
      TelemetryEntry(
        type: TelemetryEntryType.event,
        label: name,
        data: params,
        timestamp: DateTime.now(),
      ),
    );
    dev.log('event=$name params=$params', name: 'telemetry');
  }

  void logError(Object error, StackTrace stackTrace, {String? context}) {
    if (!_enabled) return;
    _addEntry(
      TelemetryEntry(
        type: TelemetryEntryType.error,
        label: context ?? 'error',
        data: {'error': error.toString()},
        timestamp: DateTime.now(),
      ),
    );
    dev.log(
      'error=$error context=$context',
      name: 'telemetry',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  void _addEntry(TelemetryEntry entry) {
    _log.insert(0, entry);
    if (_log.length > _maxEntries) {
      _log.removeRange(_maxEntries, _log.length);
    }
    _persistLog();
  }

  void _attachErrorHandlers() {
    final previousFlutterHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      previousFlutterHandler?.call(details);
      logError(
        details.exception,
        details.stack ?? StackTrace.current,
        context: details.context?.toDescription(),
      );
    };

    final previousDispatcherHandler = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      final handled = previousDispatcherHandler?.call(error, stack) ?? false;
      logError(error, stack);
      return handled;
    };
  }

  void _persistLog() {
    final prefs = _prefs;
    if (prefs == null) return;
    final encoded = jsonEncode(
      _log.map((entry) => entry.toJson()).toList(growable: false),
    );
    prefs.setString(_logPrefsKey, encoded);
  }

  void _restoreLog() {
    final raw = _prefs?.getString(_logPrefsKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _log
        ..clear()
        ..addAll(decoded.map((e) => TelemetryEntry.fromJson(e)));
    } catch (e) {
      dev.log('Failed to restore telemetry log: $e', name: 'telemetry');
      _log.clear();
    }
  }

  Future<void> clearLog() async {
    _log.clear();
    await _prefs?.remove(_logPrefsKey);
  }

  String exportLog() {
    final buffer = StringBuffer();
    for (final entry in _log.reversed) {
      buffer
        ..writeln(
          '${entry.timestamp.toIso8601String()} [${entry.type.name}] ${entry.label}',
        )
        ..writeln(entry.data == null ? '- no data' : jsonEncode(entry.data))
        ..writeln();
    }
    return buffer.toString().trim();
  }

  Future<String?> saveLogToFile() async {
    final export = exportLog();
    if (export.isEmpty) return null;
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/telemetry-log-$timestamp.txt');
    await file.writeAsString(export);
    return file.path;
  }
}

enum TelemetryEntryType { event, error }

class TelemetryEntry {
  TelemetryEntry({
    required this.type,
    required this.label,
    required this.timestamp,
    this.data,
  });

  factory TelemetryEntry.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Telemetry entry is not a map');
    }
    final typeName = json['type'] as String? ?? 'event';
    return TelemetryEntry(
      type: TelemetryEntryType.values.firstWhere(
        (t) => t.name == typeName,
        orElse: () => TelemetryEntryType.event,
      ),
      label: json['label'] as String? ?? 'unknown',
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      data: (json['data'] as Map?)?.cast<String, dynamic>(),
    );
  }

  final TelemetryEntryType type;
  final String label;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'label': label,
    'timestamp': timestamp.toIso8601String(),
    'data': data,
  };
}

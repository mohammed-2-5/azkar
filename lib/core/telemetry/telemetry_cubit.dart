import 'package:flutter_bloc/flutter_bloc.dart';

import 'telemetry_service.dart';

class TelemetryCubit extends Cubit<bool> {
  TelemetryCubit(this._service) : super(_service.enabled);

  final TelemetryService _service;

  Future<void> setEnabled(bool value) async {
    if (!value && _service.enabled) {
      _service.logEvent('telemetry_toggle', {'enabled': false});
    }
    await _service.setEnabled(value);
    emit(value);
    if (value) {
      _service.logEvent('telemetry_toggle', {'enabled': true});
      emit(state);
    } else {
      await _service.clearLog();
      emit(state);
    }
  }

  bool get isEnabled => state;

  List<TelemetryEntry> get entries => _service.entries;

  void logEvent(String name, [Map<String, dynamic>? params]) {
    _service.logEvent(name, params);
    emit(state); // notify listeners to refresh logs
  }

  void logError(Object error, StackTrace stackTrace, {String? context}) {
    _service.logError(error, stackTrace, context: context);
    emit(state);
  }

  Future<void> clearLog() async {
    await _service.clearLog();
    emit(state);
  }

  String exportLog() => _service.exportLog();

  Future<String?> saveLogToFile() => _service.saveLogToFile();
}

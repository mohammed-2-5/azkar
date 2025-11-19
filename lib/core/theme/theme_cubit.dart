import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
    : super(
          const ThemeState(
            seedColor: Colors.blueGrey,
            mode: ThemeMode.system,
            textScale: 1.0,
          ),
        );

  static const _textScaleKey = 'theme_text_scale';

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    final colorValue = sp.getInt('theme_seed');
    final modeStr = sp.getString('theme_mode');
    final storedScale = sp.getDouble(_textScaleKey);
    final mode = switch (modeStr) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final initialScale = (storedScale ?? 1.0).clamp(0.8, 1.4);
    emit(
      ThemeState(
        seedColor: Color(colorValue ?? Colors.blueGrey.value),
        mode: mode,
        textScale: initialScale.toDouble(),
      ),
    );
  }

  Future<void> setSeed(Color color) async {
    emit(state.copyWith(seedColor: color));
    final sp = await SharedPreferences.getInstance();
    await sp.setInt('theme_seed', color.value);
  }

  Future<void> setMode(ThemeMode mode) async {
    emit(state.copyWith(mode: mode));
    final sp = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await sp.setString('theme_mode', value);
  }

  Future<void> setTextScale(double scale) async {
    final clamped = scale.clamp(0.8, 1.4).toDouble();
    emit(state.copyWith(textScale: clamped));
    final sp = await SharedPreferences.getInstance();
    await sp.setDouble(_textScaleKey, clamped);
  }
}

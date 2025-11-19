import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final Color seedColor;
  final ThemeMode mode;
  final double textScale;
  const ThemeState({
    required this.seedColor,
    this.mode = ThemeMode.system,
    this.textScale = 1.0,
  });

  ThemeState copyWith({
    Color? seedColor,
    ThemeMode? mode,
    double? textScale,
  }) =>
      ThemeState(
        seedColor: seedColor ?? this.seedColor,
        mode: mode ?? this.mode,
        textScale: textScale ?? this.textScale,
      );

  @override
  List<Object?> get props => [seedColor.value, mode, textScale];
}

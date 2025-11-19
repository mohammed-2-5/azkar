import 'package:flutter/material.dart';

/// Central place for premium design primitives (colors, gradients, shadows).
class ThemeTokens {
  const ThemeTokens._();

  // Brand palette.
  static const Color midnight = Color(0xFF0F172A);
  static const Color aurora = Color(0xFF1E3A8A);
  static const Color dawn = Color(0xFFEAB676);
  static const Color jade = Color(0xFF10B981);
  static const Color blush = Color(0xFFF472B6);

  static const List<Color> heroGradient = [
    Color(0xFF0B1220),
    Color(0xFF111C32),
    Color(0xFF1C2B4F),
  ];

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0xCCFFFFFF),
      Color(0x66FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const double borderRadiusLarge = 28;
  static const double borderRadiusMedium = 20;

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 24,
      spreadRadius: -8,
      offset: Offset(0, 16),
    ),
  ];

  static ThemeData buildLightTheme(Color seed) {
    final base = ThemeData(
      colorSchemeSeed: seed,
      brightness: Brightness.light,
      useMaterial3: true,
    );
    return base.copyWith(
      scaffoldBackgroundColor: midnight,
      textTheme: base.textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusMedium)),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0x0FFFFFFF),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }

  static ThemeData buildDarkTheme(Color seed) {
    final base = ThemeData(
      colorSchemeSeed: seed,
      brightness: Brightness.dark,
      useMaterial3: true,
    );
    return base.copyWith(
      scaffoldBackgroundColor: midnight,
      cardTheme: base.cardTheme.copyWith(
        color: midnight.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusMedium)),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: Colors.white12,
      ),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MatchIqTheme {
  const MatchIqTheme._();

  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0B7A5B),
      primary: const Color(0xFF0B7A5B),
      secondary: const Color(0xFF1D4ED8),
      tertiary: const Color(0xFFEAB308),
    );

    return ThemeData(
      colorScheme: base,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7FAFC),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFFF7FAFC),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }
}

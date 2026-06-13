import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchIqTheme {
  const MatchIqTheme._();

  static ThemeData light({bool useGoogleFonts = true}) {
    final textTheme = useGoogleFonts ? GoogleFonts.interTextTheme() : null;

    final theme = FlexThemeData.light(
      scheme: FlexScheme.greenM3,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 3,
      subThemesData: const FlexSubThemesData(
        defaultRadius: 8,
        elevatedButtonRadius: 8,
        filledButtonRadius: 8,
        outlinedButtonRadius: 8,
        inputDecoratorRadius: 8,
        cardRadius: 8,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurfaceVariant,
        navigationBarSelectedIconSchemeColor: SchemeColor.primary,
        navigationBarUnselectedIconSchemeColor: SchemeColor.onSurfaceVariant,
      ),
      useMaterial3: true,
      scaffoldBackground: const Color(0xFFF7FAFC),
      fontFamily: textTheme?.bodyMedium?.fontFamily,
      textTheme: textTheme,
    );

    return theme.copyWith(
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

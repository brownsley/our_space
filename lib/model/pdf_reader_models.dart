import 'package:flutter/material.dart';

enum PdfReadingMode { light, night, eyeComfort }

class PdfReaderStyle {
  PdfReaderStyle._();

  static const Color accent = Color(0xFFE05688);
  static const Color accentDark = Color(0xFF8F3159);
  static const Color accentSoft = Color(0xFFFFE3EE);

  static const Color lightBackground = Color(0xFFFAF5F8);
  static const Color lightSurface = Colors.white;
  static const Color lightForeground = Color(0xFF30232A);
  static const Color lightMuted = Color(0xFF9B8791);
  static const Color lightBorder = Color(0xFFF4DCE7);

  static const Color darkBackground = Color(0xFF17171D);
  static const Color darkSurface = Color(0xFF24242D);
  static const Color darkForeground = Color(0xFFF5EEF4);
  static const Color darkMuted = Color(0xFFB8ADB9);
  static const Color darkBorder = Color(0xFF393540);

  static const Color sepiaBackground = Color(0xFFF2E6CE);
  static const Color sepiaSurface = Color(0xFFE9D9BB);
  static const Color sepiaForeground = Color(0xFF493A2C);
  static const Color sepiaMuted = Color(0xFF82715C);
  static const Color sepiaBorder = Color(0xFFDCC9A7);

  static Color background(PdfReadingMode mode) {
    switch (mode) {
      case PdfReadingMode.light:
        return lightBackground;
      case PdfReadingMode.night:
        return darkBackground;
      case PdfReadingMode.eyeComfort:
        return sepiaBackground;
    }
  }

  static Color surface(PdfReadingMode mode) {
    switch (mode) {
      case PdfReadingMode.light:
        return lightSurface;
      case PdfReadingMode.night:
        return darkSurface;
      case PdfReadingMode.eyeComfort:
        return sepiaSurface;
    }
  }

  static Color foreground(PdfReadingMode mode) {
    switch (mode) {
      case PdfReadingMode.light:
        return lightForeground;
      case PdfReadingMode.night:
        return darkForeground;
      case PdfReadingMode.eyeComfort:
        return sepiaForeground;
    }
  }

  static Color mutedForeground(PdfReadingMode mode) {
    switch (mode) {
      case PdfReadingMode.light:
        return lightMuted;
      case PdfReadingMode.night:
        return darkMuted;
      case PdfReadingMode.eyeComfort:
        return sepiaMuted;
    }
  }

  static Color border(PdfReadingMode mode) {
    switch (mode) {
      case PdfReadingMode.light:
        return lightBorder;
      case PdfReadingMode.night:
        return darkBorder;
      case PdfReadingMode.eyeComfort:
        return sepiaBorder;
    }
  }

  static Color accentSurface(PdfReadingMode mode) {
    switch (mode) {
      case PdfReadingMode.light:
        return accentSoft;
      case PdfReadingMode.night:
        return const Color(0xFF422638);
      case PdfReadingMode.eyeComfort:
        return const Color(0xFFE8D4D4);
    }
  }

  static Color progressBackground(PdfReadingMode mode) {
    return accent.withOpacity(mode == PdfReadingMode.night ? 0.25 : 0.12);
  }

  static ColorFilter colorFilter(PdfReadingMode mode) {
    switch (mode) {
      case PdfReadingMode.light:
        return const ColorFilter.mode(Colors.transparent, BlendMode.dst);

      case PdfReadingMode.night:
        return const ColorFilter.matrix([
          -1,
          0,
          0,
          0,
          255,
          0,
          -1,
          0,
          0,
          255,
          0,
          0,
          -1,
          0,
          255,
          0,
          0,
          0,
          1,
          0,
        ]);

      case PdfReadingMode.eyeComfort:
        return const ColorFilter.matrix([
          0.75,
          0.25,
          0.10,
          0,
          12,
          0.20,
          0.70,
          0.10,
          0,
          8,
          0.10,
          0.20,
          0.55,
          0,
          4,
          0,
          0,
          0,
          1,
          0,
        ]);
    }
  }

  static ThemeData theme(PdfReadingMode mode) {
    final isDark = mode == PdfReadingMode.night;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: background(mode),
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: accent,
        surface: surface(mode),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface(mode),
        foregroundColor: foreground(mode),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface(mode),
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: border(mode),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: accentDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

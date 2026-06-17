import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'n_color_palette.dart';
import 'n_typography.dart';

double _relativeLuminance(Color c) {
  final r = _linearize(c.r);
  final g = _linearize(c.g);
  final b = _linearize(c.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _linearize(double channel) {
  return channel <= 0.04045
      ? channel / 12.92
      : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
}

Color _readableOn(Color bg) {
  return _relativeLuminance(bg) > 0.179 ? const Color(0xFF18181B) : Colors.white;
}

ColorScheme buildColorScheme(NColorPalette palette, Brightness brightness) {
  final factory =
      brightness == Brightness.light ? ColorScheme.light : ColorScheme.dark;
  return factory(
    primary: palette.primary,
    onPrimary: _readableOn(palette.primary),
    secondary: palette.secondary,
    onSecondary: _readableOn(palette.secondary),
    tertiary: palette.info,
    surface: brightness == Brightness.light
        ? palette.bgDefault
        : palette.bgElevated,
    onSurface: palette.textDefault,
    error: palette.error,
    onError: _readableOn(palette.error),
    surfaceContainerHighest: palette.bgMuted,
  );
}

TextTheme buildTextTheme(NColorPalette palette, Brightness brightness,
    {double textScale = 1.0, NTypography? typography}) {
  final base = typography?.resolveTextTheme(brightness) ??
      (brightness == Brightness.light
          ? ThemeData.light().textTheme
          : ThemeData.dark().textTheme);
  final color = palette.textDefault;

  return base
      .copyWith(
        displayLarge: base.displayLarge?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: (72 * textScale),
          letterSpacing: -0.02,
          height: 1,
        ),
        displayMedium: base.displayMedium?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: (60 * textScale),
          letterSpacing: -0.02,
          height: 1,
        ),
        displaySmall: base.displaySmall?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: (48 * textScale),
          letterSpacing: -0.02,
          height: 1,
        ),
        headlineLarge: base.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: (36 * textScale),
          letterSpacing: -0.02,
          height: 1.1,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: (30 * textScale),
          letterSpacing: -0.01,
          height: 1.2,
        ),
        headlineSmall: base.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: (24 * textScale),
          letterSpacing: -0.01,
          height: 1.25,
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: (20 * textScale),
          letterSpacing: -0.01,
          height: 1.3,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: (18 * textScale),
          letterSpacing: -0.01,
          height: 1.35,
        ),
        titleSmall: base.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: (16 * textScale),
          height: 1.4,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: (16 * textScale),
          height: 1.5,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: (14 * textScale),
          height: 1.5,
        ),
        bodySmall: base.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: (12 * textScale),
          height: 1.5,
        ),
        labelLarge: base.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: (14 * textScale),
          height: 1.25,
          letterSpacing: 0.01,
        ),
        labelMedium: base.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: (12 * textScale),
          height: 1.25,
          letterSpacing: 0.01,
        ),
        labelSmall: base.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: (11 * textScale),
          height: 1.25,
          letterSpacing: 0.02,
        ),
      )
      .apply(
        bodyColor: color,
        displayColor: color,
      );
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nui_flutter/src/theme/n_color_palette.dart';
import 'package:nui_flutter/src/theme/n_color_mapping.dart';

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

double _contrastRatio(Color a, Color b) {
  final l1 = _relativeLuminance(a);
  final l2 = _relativeLuminance(b);
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  late NColorPalette lightPalette;
  late NColorPalette darkPalette;
  late ColorScheme lightScheme;
  late ColorScheme darkScheme;

  setUp(() {
    lightPalette = NColorPalette.light(
      primary: const Color(0xFFF97316),
      secondary: const Color(0xFF6B7280),
      success: const Color(0xFF10B981),
      error: const Color(0xFFEF4444),
    );
    darkPalette = NColorPalette.dark(
      primary: const Color(0xFFF97316),
      secondary: const Color(0xFF6B7280),
      success: const Color(0xFF10B981),
      error: const Color(0xFFEF4444),
    );
    lightScheme = buildColorScheme(lightPalette, Brightness.light);
    darkScheme = buildColorScheme(darkPalette, Brightness.dark);
  });

  group('WCAG AA contrast — light', () {
    test('primary / onPrimary >= 4.5:1', () {
      expect(_contrastRatio(lightScheme.primary, lightScheme.onPrimary),
          greaterThanOrEqualTo(4.5));
    });

    test('secondary / onSecondary >= 4.5:1', () {
      expect(_contrastRatio(lightScheme.secondary, lightScheme.onSecondary),
          greaterThanOrEqualTo(4.5));
    });

    test('error / onError >= 4.5:1', () {
      expect(_contrastRatio(lightScheme.error, lightScheme.onError),
          greaterThanOrEqualTo(4.5));
    });

    test('surface / onSurface >= 4.5:1', () {
      expect(_contrastRatio(lightScheme.surface, lightScheme.onSurface),
          greaterThanOrEqualTo(4.5));
    });
  });

  group('WCAG AA contrast — dark', () {
    test('primary / onPrimary >= 4.5:1', () {
      expect(_contrastRatio(darkScheme.primary, darkScheme.onPrimary),
          greaterThanOrEqualTo(4.5));
    });

    test('secondary / onSecondary >= 4.5:1', () {
      expect(_contrastRatio(darkScheme.secondary, darkScheme.onSecondary),
          greaterThanOrEqualTo(4.5));
    });

    test('error / onError >= 4.5:1', () {
      expect(_contrastRatio(darkScheme.error, darkScheme.onError),
          greaterThanOrEqualTo(4.5));
    });

    test('surface / onSurface >= 4.5:1', () {
      expect(_contrastRatio(darkScheme.surface, darkScheme.onSurface),
          greaterThanOrEqualTo(4.5));
    });
  });
}

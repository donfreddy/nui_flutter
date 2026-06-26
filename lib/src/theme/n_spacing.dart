import 'package:flutter/material.dart';

/// A set of static spacing constants following the complete Tailwind spacing scale
/// (4 dp base unit, matching Tailwind CSS `space-*` tokens 1-to-1).
///
/// Use these values for padding, margin, gap, and size to keep spacing
/// consistent across all screens and components.
///
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(NSpacing.s4),
///   child: child,
/// )
/// ```
abstract class NSpacing {
  // ---------------------------------------------------------------------------
  // Base scale (complete Tailwind spacing scale - 4 dp grid)
  // ---------------------------------------------------------------------------

  /// 0 dp.
  static double get s0 => 0;

  /// 2 dp.
  static double get s0_5 => 2.0;

  /// 4 dp.
  static double get s1 => 4.0;

  /// 6 dp.
  static double get s1_5 => 6.0;

  /// 8 dp.
  static double get s2 => 8.0;

  /// 10 dp.
  static double get s2_5 => 10.0;

  /// 12 dp.
  static double get s3 => 12.0;

  /// 14 dp.
  static double get s3_5 => 14.0;

  /// 16 dp.
  static double get s4 => 16.0;

  /// 20 dp.
  static double get s5 => 20.0;

  /// 24 dp.
  static double get s6 => 24.0;

  /// 28 dp.
  static double get s7 => 28.0;

  /// 32 dp.
  static double get s8 => 32.0;

  /// 36 dp.
  static double get s9 => 36.0;

  /// 40 dp.
  static double get s10 => 40.0;

  /// 44 dp.
  static double get s11 => 44.0;

  /// 48 dp.
  static double get s12 => 48.0;

  /// 56 dp.
  static double get s14 => 56.0;

  /// 64 dp.
  static double get s16 => 64.0;

  // ---------------------------------------------------------------------------
  // Semantic aliases
  // ---------------------------------------------------------------------------

  /// 2 dp. Micro gap between tightly packed elements (e.g., icon and badge).
  static double get micro => s0_5;

  /// 4 dp. Tight gap between closely related elements (e.g., icon and label).
  static double get tight => s1;

  /// 8 dp. Normal gap between sibling elements.
  static double get normal => s2;

  /// 16 dp. Comfortable padding for component interiors.
  static double get comfortable => s4;

  /// 24 dp. Spacious gap between distinct sections.
  static double get spacious => s6;

  /// 32 dp. Extra-spacious gap for major layout sections.
  static double get extraSpacious => s8;

  /// 16 dp. Standard inner padding for interactive components.
  static double get componentPadding => s4;

  /// 12 dp. Vertical or horizontal gap between list items.
  static double get itemGap => s3;

  /// 24 dp. Gap between separate content sections.
  static double get sectionGap => s6;

  /// 16 dp. Horizontal padding applied to full-width screen content.
  static double get screenPadding => s4;

  // ---------------------------------------------------------------------------
  // EdgeInsets semantic shortcuts
  // ---------------------------------------------------------------------------

  /// 16 dp horizontal page padding.
  static final EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: s4);

  /// 16 dp card internal padding.
  static final EdgeInsets cardPadding = EdgeInsets.all(s4);

  // ---------------------------------------------------------------------------
  // SizedBox helpers
  // ---------------------------------------------------------------------------

  /// Returns a [SizedBox] with the given [value] as its height.
  static Widget vertical(double value) => SizedBox(height: value);

  /// Returns a [SizedBox] with the given [value] as its width.
  static Widget horizontal(double value) => SizedBox(width: value);

  /// Returns a square [SizedBox] with both dimensions equal to [value].
  static Widget square(double value) => SizedBox.square(dimension: value);
}

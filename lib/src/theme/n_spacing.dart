import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A set of static spacing constants following a Tailwind-inspired 4 dp base scale.
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
  // Base scale (4 dp grid)
  // ---------------------------------------------------------------------------

  /// 0 dp.
  static double get s0 => 0;

  /// 4 dp.
  static double get s1 => 4.0;

  /// 8 dp.
  static double get s2 => 8.0;

  /// 12 dp.
  static double get s3 => 12.0;

  /// 16 dp.
  static double get s4 => 16.0;

  /// 20 dp.
  static double get s5 => 20.0;

  /// 24 dp.
  static double get s6 => 24.0;

  /// 32 dp.
  static double get s8 => 32.0;

  /// 48 dp.
  static double get s12 => 48.0;

  /// 64 dp.
  static double get s16 => 64.0;

  // ---------------------------------------------------------------------------
  // Semantic aliases
  // ---------------------------------------------------------------------------

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
  // SizedBox helpers
  // ---------------------------------------------------------------------------

  /// Returns a [SizedBox] with height equal to [value] scaled by
  /// [flutter_screenutil]'s height factor.
  static Widget vertical(double value) => SizedBox(height: value.h);

  /// Returns a [SizedBox] with width equal to [value] scaled by
  /// [flutter_screenutil]'s width factor.
  static Widget horizontal(double value) => SizedBox(width: value.w);

  /// Returns a square [SizedBox] with both dimensions equal to [value] scaled
  /// by [flutter_screenutil]'s diagonal factor.
  static Widget square(double value) => SizedBox.square(dimension: value.dg);
}

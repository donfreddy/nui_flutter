import 'dart:ui';
import 'package:flutter/material.dart';

/// A spacing scale driven by a single [base] value (4 dp by default),
/// registered as a [ThemeExtension] so it can be read anywhere via
/// `context.nui.spacing` or the static [NSpacing.standard] for convenience.
///
/// All steps derive proportionally from [base], mirroring the Tailwind CSS
/// spacing scale (4 dp grid).
///
/// ```dart
/// // In a build method (per-theme customisable):
/// Padding(padding: EdgeInsets.all(context.nui.spacing.s4), child: child)
///
/// // Outside a build method (standard scale):
/// Padding(padding: EdgeInsets.all(NSpacing.standard.s4), child: child)
/// ```
@immutable
class NSpacing extends ThemeExtension<NSpacing> {
  /// The standard spacing scale (base = 4 dp), matching the Tailwind grid.
  static const NSpacing standard = NSpacing();

  /// Creates a spacing scale from a single [base] value.
  ///
  /// All other steps are derived proportionally from [base].
  const NSpacing({this.base = 4.0});

  /// The base spacing unit in logical pixels. Defaults to 4.0.
  final double base;

  // ---------------------------------------------------------------------------
  // Base scale (complete Tailwind spacing scale - 4 dp grid)
  // ---------------------------------------------------------------------------

  double get s0 => 0;
  double get s0_5 => base * 0.5;
  double get s1 => base * 1;
  double get s1_5 => base * 1.5;
  double get s2 => base * 2;
  double get s2_5 => base * 2.5;
  double get s3 => base * 3;
  double get s3_5 => base * 3.5;
  double get s4 => base * 4;
  double get s5 => base * 5;
  double get s6 => base * 6;
  double get s7 => base * 7;
  double get s8 => base * 8;
  double get s9 => base * 9;
  double get s10 => base * 10;
  double get s11 => base * 11;
  double get s12 => base * 12;
  double get s14 => base * 14;
  double get s16 => base * 16;

  // ---------------------------------------------------------------------------
  // Semantic aliases
  // ---------------------------------------------------------------------------

  double get micro => s0_5;
  double get tight => s1;
  double get normal => s2;
  double get comfortable => s4;
  double get spacious => s6;
  double get extraSpacious => s8;
  double get componentPadding => s4;
  double get itemGap => s3;
  double get sectionGap => s6;
  double get screenPadding => s4;

  // ---------------------------------------------------------------------------
  // EdgeInsets semantic shortcuts
  // ---------------------------------------------------------------------------

  EdgeInsets get pagePadding => EdgeInsets.symmetric(horizontal: s4);
  EdgeInsets get cardPadding => EdgeInsets.all(s4);

  // ---------------------------------------------------------------------------
  // SizedBox helpers (static — context-independent utilities)
  // ---------------------------------------------------------------------------

  static Widget vertical(double value) => SizedBox(height: value);
  static Widget horizontal(double value) => SizedBox(width: value);
  static Widget square(double value) => SizedBox.square(dimension: value);

  // ---------------------------------------------------------------------------
  // ThemeExtension overrides
  // ---------------------------------------------------------------------------

  @override
  NSpacing copyWith({double? base}) => NSpacing(base: base ?? this.base);

  @override
  NSpacing lerp(ThemeExtension<NSpacing>? other, double t) {
    if (other is! NSpacing) return this;
    return NSpacing(base: lerpDouble(base, other.base, t)!);
  }

  // ---------------------------------------------------------------------------
  // Equality
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NSpacing && other.base == base;

  @override
  int get hashCode => base.hashCode;

  @override
  String toString() => 'NSpacing(base: $base)';
}

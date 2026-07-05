import 'dart:ui';

import 'package:flutter/material.dart' show ThemeExtension;
import 'package:flutter/widgets.dart';

/// A radius scale driven by a single [base] value, registered as a
/// [ThemeExtension] so it can be read anywhere via
/// `Theme.of(context).extension<NRadius>()` or `context.nui.radius`.
///
/// All semantic steps (`xs`, `sm`, `md`, `lg`, `xl`, `xl2`, `full`) are
/// derived from [base] so changing one value propagates consistently.
///
/// ```dart
/// NApp(
///   radius: const NRadius(base: 12), // rounder UI
///   ...
/// )
///
/// // Reading anywhere:
/// final r = context.nui.radius;
/// BorderRadius.circular(r.md); // 12 dp
/// ```
///
/// Default [base] is `8.0` (matches original NTokens.radiusDefault).
@immutable
class NRadius extends ThemeExtension<NRadius> {
  /// Creates a radius scale from a single [base] value.
  ///
  /// All other steps are derived proportionally from [base].
  const NRadius({this.base = 8.0});

  /// The base radius in logical pixels. Defaults to `8.0`.
  final double base;

  // ---------------------------------------------------------------------------
  // Numeric steps
  // ---------------------------------------------------------------------------

  /// Extra-small radius: `base * 0.5` (min 2 dp).
  double get xs => (base * 0.5).clamp(2.0, double.infinity);

  /// Small radius: `base * 0.75`.
  double get sm => base * 0.75;

  /// Medium (default) radius: equals [base].
  double get md => base;

  /// Large radius: `base * 1.5`.
  double get lg => base * 1.5;

  /// Extra-large radius: `base * 2`.
  double get xl => base * 2.0;

  /// 2×XL radius: `base * 3`.
  double get xl2 => base * 3.0;

  /// Full pill shape (9999 dp).
  double get full => 9999.0;

  // ---------------------------------------------------------------------------
  // BorderRadius helpers
  // ---------------------------------------------------------------------------

  /// Circular [BorderRadius] for the [xs] step.
  BorderRadius get radiusXs => BorderRadius.circular(xs);

  /// Circular [BorderRadius] for the [sm] step.
  BorderRadius get radiusSm => BorderRadius.circular(sm);

  /// Circular [BorderRadius] for the [md] step.
  BorderRadius get radiusMd => BorderRadius.circular(md);

  /// Circular [BorderRadius] for the [lg] step.
  BorderRadius get radiusLg => BorderRadius.circular(lg);

  /// Circular [BorderRadius] for the [xl] step.
  BorderRadius get radiusXl => BorderRadius.circular(xl);

  /// Circular [BorderRadius] for the [xl2] step.
  BorderRadius get radiusXl2 => BorderRadius.circular(xl2);

  /// Circular [BorderRadius] for the [full] (pill) step.
  BorderRadius get radiusFull => BorderRadius.circular(full);

  // ---------------------------------------------------------------------------
  // ThemeExtension overrides
  // ---------------------------------------------------------------------------

  @override
  NRadius copyWith({double? base}) => NRadius(base: base ?? this.base);

  @override
  NRadius lerp(ThemeExtension<NRadius>? other, double t) {
    if (other is! NRadius) return this;
    return NRadius(base: lerpDouble(base, other.base, t)!);
  }

  // ---------------------------------------------------------------------------
  // Equality
  // ---------------------------------------------------------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NRadius && other.base == base;

  @override
  int get hashCode => base.hashCode;

  @override
  String toString() => 'NRadius(base: $base)';
}

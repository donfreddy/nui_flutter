import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A set of elevation shadows for light and dark modes, registered as a
/// [ThemeExtension] so it can be read anywhere via
/// `Theme.of(context).extension<NShadows>()` or `context.nui.shadows`.
///
/// Each level maps to a Material-like elevation step.
///
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: context.nui.shadows.sm,
///   ),
/// )
/// ```
@immutable
class NShadows extends ThemeExtension<NShadows> {
  /// Creates a shadow set. Prefer [NShadows.light] or [NShadows.dark].
  const NShadows({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xl2,
  });

  /// Subtle shadow: cards, inputs (1–2 dp).
  final List<BoxShadow> sm;

  /// Default component shadow: dropdowns, tooltips (2–4 dp).
  final List<BoxShadow> md;

  /// Elevated component shadow: modals, popovers (4–8 dp).
  final List<BoxShadow> lg;

  /// High elevation shadow: drawers, bottom sheets (8–16 dp).
  final List<BoxShadow> xl;

  /// Maximum elevation shadow: full-screen overlays (12–24 dp).
  final List<BoxShadow> xl2;

  // ---------------------------------------------------------------------------
  // Factories
  // ---------------------------------------------------------------------------

  /// Light-mode shadow set (soft, layered key + ambient).
  factory NShadows.light() {
    return const NShadows(
      sm: [
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
      md: [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
      lg: [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
      xl: [
        BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
      xl2: [
        BoxShadow(
          color: Color(0x29000000),
          blurRadius: 48,
          offset: Offset(0, 20),
        ),
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    );
  }

  /// Dark-mode shadow set (deeper, higher alpha).
  factory NShadows.dark() {
    return const NShadows(
      sm: [
        BoxShadow(
          color: Color(0x3D000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ],
      md: [
        BoxShadow(
          color: Color(0x52000000),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
      lg: [
        BoxShadow(
          color: Color(0x66000000),
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ],
      xl: [
        BoxShadow(
          color: Color(0x7A000000),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
      ],
      xl2: [
        BoxShadow(
          color: Color(0x8F000000),
          blurRadius: 48,
          offset: Offset(0, 20),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Convenience
  // ---------------------------------------------------------------------------

  /// Empty shadow list: use when elevation is `0`.
  static const List<BoxShadow> none = [];

  // ---------------------------------------------------------------------------
  // ThemeExtension overrides
  // ---------------------------------------------------------------------------

  @override
  NShadows copyWith({
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
    List<BoxShadow>? xl,
    List<BoxShadow>? xl2,
  }) {
    return NShadows(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xl2: xl2 ?? this.xl2,
    );
  }

  /// Shadows snap at the midpoint: interpolating `BoxShadow` lists is
  /// complex and rarely needed. Override if you need smooth shadow transitions.
  @override
  NShadows lerp(ThemeExtension<NShadows>? other, double t) {
    if (other is! NShadows) return this;
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NShadows &&
          listEquals(sm, other.sm) &&
          listEquals(md, other.md) &&
          listEquals(lg, other.lg) &&
          listEquals(xl, other.xl) &&
          listEquals(xl2, other.xl2);

  @override
  int get hashCode => Object.hash(sm, md, lg, xl, xl2);
}

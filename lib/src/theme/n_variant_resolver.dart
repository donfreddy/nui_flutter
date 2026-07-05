import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/widgets.dart';


/// The shared visual variants used across interactive surfaces.
enum NVariant {
  /// Filled with the role color.
  solid,

  /// Transparent with a tinted border.
  outline,

  /// Low-opacity tinted fill.
  soft,

  /// Tinted fill with a tinted border.
  subtle,

  /// Transparent, no border.
  ghost,

  /// Inline text style.
  link,
}

/// Centralized validation registry to ensure components only use variants
/// that make sense for their visual design.
abstract final class NVariantSupport {
  /// All variants are supported by buttons.
  static const Set<NVariant> button = {
    NVariant.solid,
    NVariant.outline,
    NVariant.soft,
    NVariant.subtle,
    NVariant.ghost,
    NVariant.link,
  };

  /// Badges typically do not support link or ghost forms.
  static const Set<NVariant> badge = {
    NVariant.solid,
    NVariant.outline,
    NVariant.soft,
    NVariant.subtle,
  };

  /// Alerts typically use solid, outline, soft, or subtle.
  static const Set<NVariant> alert = {
    NVariant.solid,
    NVariant.outline,
    NVariant.soft,
    NVariant.subtle,
  };

  /// Chips support solid, soft, and outline variants.
  static const Set<NVariant> chip = {
    NVariant.solid,
    NVariant.soft,
    NVariant.outline,
  };

  /// Progress bars typically only use solid or soft.
  static const Set<NVariant> progress = {
    NVariant.solid,
    NVariant.soft,
  };
}

/// The resolved paint for a variant: background, foreground, and border color.
///
/// A `null` field means "paint nothing" (e.g. transparent background, no border).
/// Foreground is always present.
@immutable
class NResolvedColors {
  /// Creates a resolved color triple.
  const NResolvedColors({
    required this.foreground,
    this.background,
    this.border,
  });

  /// Text / icon color.
  final Color foreground;

  /// Fill color, or `null` for transparent.
  final Color? background;

  /// 1px border color, or `null` for none.
  final Color? border;
}

/// Utility for calculating contrast colors.
Color _nOnColor(Color background) {
  // Simple brightness calculation to determine contrast color.
  // Using relative luminance based on WCAG.
  final luminance =
      (0.299 * background.r + 0.587 * background.g + 0.114 * background.b);
  return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
}

/// Utility for creating tints (opacity over white/black based on context).
/// In Flutter, simple opacity works best for tints.
Color _nOpacity(Color base, double opacity) {
  return base.withValues(alpha: opacity);
}

/// Resolves `(role, variant)` to concrete colors against an [NColors] set.
abstract final class NVariantResolver {
  /// Resolves the paint for [role] and [variant] under [colors].
  static NResolvedColors resolve(
    NColorRole role,
    NVariant variant,
    NColors colors,
  ) {
    final isNeutral = role == NColorRole.neutral;
    final base = isNeutral ? colors.textHighlighted : colors.role(role);
    final onSolid = _nOnColor(base);
    Color tint(double pct) => _nOpacity(base, pct / 100);

    switch (variant) {
      case NVariant.outline:
        return isNeutral
            ? NResolvedColors(
                foreground: colors.text,
                border: colors.borderAccented,
              )
            : NResolvedColors(foreground: base, border: tint(50));
      case NVariant.soft:
        return isNeutral
            ? NResolvedColors(
                foreground: colors.textHighlighted,
                background: colors.bgElevated,
              )
            : NResolvedColors(foreground: base, background: tint(12));
      case NVariant.subtle:
        return isNeutral
            ? NResolvedColors(
                foreground: colors.textHighlighted,
                background: colors.bgElevated,
                border: colors.borderAccented,
              )
            : NResolvedColors(
                foreground: base,
                background: tint(12),
                border: tint(28),
              );
      case NVariant.ghost:
        return NResolvedColors(
          foreground: isNeutral ? colors.text : base,
        );
      case NVariant.link:
        return NResolvedColors(
          foreground: isNeutral ? colors.textMuted : base,
        );
      case NVariant.solid:
        return isNeutral
            ? NResolvedColors(
                foreground: colors.textInverted,
                background: colors.bgInverted,
              )
            : NResolvedColors(foreground: onSolid, background: base);
    }
  }
}

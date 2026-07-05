import 'package:flutter/widgets.dart';
import 'package:nui_flutter/src/tokens/n_color_roles.dart';
import 'package:nui_flutter/src/theme/n_colors.dart';
import 'package:nui_flutter/src/tokens/n_variant.dart';

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

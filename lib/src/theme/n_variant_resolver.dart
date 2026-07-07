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

/// Utility for calculating a legible foreground on a solid background.
Color _nOnColor(Color background) {
  final luminance =
      (0.299 * background.r + 0.587 * background.g + 0.114 * background.b);
  return luminance > 0.5 ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
}

/// Resolves `(role, variant)` to concrete colours against an [NColors] set.
///
/// For role-colored components the resolution uses the role's 11-step
/// [NColorScale] so that the resulting shades mirror Tailwind's hand-tuned
/// palettes (e.g. soft → scale.s100 bg + scale.s700 text). For the neutral
/// role the resolution uses the surface-hierarchy tokens directly.
abstract final class NVariantResolver {
  /// Resolves the paint for [role] and [variant] under [colors].
  static NResolvedColors resolve(
    NColorRole role,
    NVariant variant,
    NColors colors,
  ) {
    final isNeutral = role == NColorRole.neutral;
    final scale = colors.scaleFor(role);

    switch (variant) {
      case NVariant.outline:
        return isNeutral
            ? NResolvedColors(
                foreground: colors.text,
                border: colors.borderAccented,
              )
            : NResolvedColors(foreground: scale.s500, border: scale.s300);
      case NVariant.soft:
        return isNeutral
            ? NResolvedColors(
                foreground: colors.textHighlighted,
                background: colors.bgElevated,
              )
            : NResolvedColors(foreground: scale.s700, background: scale.s100);
      case NVariant.subtle:
        return isNeutral
            ? NResolvedColors(
                foreground: colors.textHighlighted,
                background: colors.bgElevated,
                border: colors.borderAccented,
              )
            : NResolvedColors(
                foreground: scale.s700,
                background: scale.s100,
                border: scale.s300,
              );
      case NVariant.ghost:
        return NResolvedColors(
          foreground: isNeutral ? colors.text : scale.s500,
        );
      case NVariant.link:
        return NResolvedColors(
          foreground: isNeutral ? colors.textMuted : scale.s500,
        );
      case NVariant.solid:
        return isNeutral
            ? NResolvedColors(
                foreground: colors.textInverted,
                background: colors.bgInverted,
              )
            : NResolvedColors(
                foreground: _nOnColor(scale.s500),
                background: scale.s500,
              );
    }
  }
}

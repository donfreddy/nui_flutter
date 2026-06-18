import 'package:flutter/material.dart';
import 'n_tokens.dart';

/// Shared semantic color roles used by all NUI components.
///
/// Each value maps to a set of [NTokens] colors (main, soft-bg, border, text,
/// foreground). Components that need a custom neutral mapping can override
/// via [NComponentColors.resolve] optional parameters.
enum NComponentColor {
  /// Maps to [NTokens.primary] and the related primary tint tokens.
  primary,

  /// Maps to [NTokens.secondary] and the related secondary tint tokens.
  secondary,

  /// Maps to [NTokens.success] and the related success tint tokens.
  success,

  /// Maps to [NTokens.info] and the related info tint tokens.
  info,

  /// Maps to [NTokens.warning] and the related warning tint tokens.
  warning,

  /// Maps to [NTokens.error] and the related error tint tokens.
  error,

  /// Maps to neutral surface tokens. Defaults can be overridden via the
  /// optional parameters on [NComponentColors.resolve].
  neutral,
}

/// Resolved color values for a given [NComponentColor] role.
///
/// Returned by [NComponentColors.resolve] and consumed by each component's
/// variant switch inside its `_getColors` method.
class NComponentColors {
  /// The main (saturated) color for the role, used for backgrounds and borders
  /// in solid/filled variants.
  final Color main;

  /// The foreground color to render on top of [main] (typically white or dark).
  final Color foreground;

  /// A lightly tinted surface color derived from [main] for soft/subtle variants.
  final Color softBg;

  /// A tinted border color derived from [main].
  final Color border;

  /// Text color suitable for use on [softBg] surfaces.
  final Color text;

  /// Creates a fully resolved [NComponentColors] bundle.
  const NComponentColors({
    required this.main,
    required this.foreground,
    required this.softBg,
    required this.border,
    required this.text,
  });

  /// Resolves the full set of colors for [color] from the nearest [BuildContext].
  ///
  /// Optional parameters let the caller override the neutral role's individual
  /// tokens without affecting any of the semantic roles:
  ///
  /// * [neutralMain] overrides the color used for the neutral `main` slot.
  /// * [neutralForeground] overrides the color for the neutral foreground.
  /// * [neutralSoftBg] overrides the color for the neutral soft background.
  /// * [neutralBorder] overrides the color for the neutral border.
  /// * [neutralText] overrides the color for the neutral text.
  factory NComponentColors.resolve(
    BuildContext context,
    NComponentColor color, {
    Color Function(BuildContext)? neutralMain,
    Color Function(BuildContext)? neutralForeground,
    Color Function(BuildContext)? neutralSoftBg,
    Color Function(BuildContext)? neutralBorder,
    Color Function(BuildContext)? neutralText,
  }) {
    switch (color) {
      case NComponentColor.primary:
        return NComponentColors(
          main: NTokens.primary(context),
          foreground: NTokens.textInverted(context),
          softBg: NTokens.primaryBg(context),
          border: NTokens.primaryBorder(context),
          text: NTokens.primaryText(context),
        );
      case NComponentColor.secondary:
        return NComponentColors(
          main: NTokens.secondary(context),
          foreground: NTokens.textInverted(context),
          softBg: NTokens.secondaryBg(context),
          border: NTokens.secondaryBorder(context),
          text: NTokens.secondaryText(context),
        );
      case NComponentColor.success:
        return NComponentColors(
          main: NTokens.success(context),
          foreground: NTokens.textInverted(context),
          softBg: NTokens.successBg(context),
          border: NTokens.successBorder(context),
          text: NTokens.successText(context),
        );
      case NComponentColor.info:
        return NComponentColors(
          main: NTokens.info(context),
          foreground: NTokens.textInverted(context),
          softBg: NTokens.infoBg(context),
          border: NTokens.infoBorder(context),
          text: NTokens.infoText(context),
        );
      case NComponentColor.warning:
        return NComponentColors(
          main: NTokens.warning(context),
          foreground: NTokens.textInverted(context),
          softBg: NTokens.warningBg(context),
          border: NTokens.warningBorder(context),
          text: NTokens.warningText(context),
        );
      case NComponentColor.error:
        return NComponentColors(
          main: NTokens.error(context),
          foreground: NTokens.textInverted(context),
          softBg: NTokens.errorBg(context),
          border: NTokens.errorBorder(context),
          text: NTokens.errorText(context),
        );
      case NComponentColor.neutral:
        return NComponentColors(
          main: neutralMain?.call(context) ?? NTokens.textDefault(context),
          foreground: neutralForeground?.call(context) ?? NTokens.bgDefault(context),
          softBg: neutralSoftBg?.call(context) ?? NTokens.bgMuted(context),
          border: neutralBorder?.call(context) ?? NTokens.borderDefault(context),
          text: neutralText?.call(context) ?? NTokens.textDefault(context),
        );
    }
  }

  /// Shorthand for [NComponentColors.resolve] when no neutral overrides are needed.
  factory NComponentColors.resolveSimple(
    BuildContext context,
    NComponentColor color,
  ) {
    return NComponentColors.resolve(context, color);
  }
}

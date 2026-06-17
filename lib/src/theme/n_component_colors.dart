import 'package:flutter/material.dart';
import 'n_tokens.dart';

/// Shared semantic color roles used by all NUI components.
///
/// Each value maps to a set of [NTokens] colors (main, soft-bg, border, text,
/// foreground). Components that need a custom neutral mapping can override
/// via [NComponentColors.resolve] optional parameters.
enum NComponentColor {
  primary,
  secondary,
  success,
  info,
  warning,
  error,
  neutral,
}

/// Resolved color values for a given [NComponentColor] role.
///
/// Returned by [resolveComponentColors] and consumed by each component's
/// variant switch inside its `_getColors` method.
class NComponentColors {
  final Color main;
  final Color foreground;
  final Color softBg;
  final Color border;
  final Color text;

  const NComponentColors({
    required this.main,
    required this.foreground,
    required this.softBg,
    required this.border,
    required this.text,
  });

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

  /// Shorthand for non-neutral resolve without optional params.
  factory NComponentColors.resolveSimple(
    BuildContext context,
    NComponentColor color,
  ) {
    return NComponentColors.resolve(context, color);
  }
}

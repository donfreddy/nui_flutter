import 'package:flutter/material.dart';
import '../../theme/n_tokens.dart';
import '../../theme/n_component_colors.dart';

/// The visual style of an [NIconButton].
enum NIconButtonVariant {
  /// Filled background using the button color.
  solid,

  /// Lightly tinted background using a low-opacity version of the button color.
  soft,

  /// Transparent background with a colored border.
  outline,

  /// Fully transparent background and no border.
  ghost,
}

/// The semantic color role applied to an [NIconButton].
enum NIconButtonColor {
  /// Uses the primary brand color.
  primary,

  /// Uses the secondary accent color.
  secondary,

  /// Uses the success color.
  success,

  /// Uses the informational color.
  info,

  /// Uses the warning color.
  warning,

  /// Uses the error color.
  error,

  /// Uses a neutral muted color.
  neutral,
}

/// The size of an [NIconButton], controlling padding, icon size, and corner radius.
enum NIconButtonSize {
  /// Small (16 dp icon, 8 dp padding).
  sm,

  /// Medium (20 dp icon, 10 dp padding). The default size.
  md,

  /// Large (24 dp icon, 12 dp padding).
  lg,
}

/// An icon-only button with four visual variants and seven semantic color roles.
///
/// Use [NIconButton.sm] or [NIconButton.lg] for convenient size shortcuts.
/// An optional [tooltip] is shown on long-press.
///
/// ```dart
/// NIconButton(
///   icon: LucideIcons.bell,
///   onPressed: _openNotifications,
///   variant: NIconButtonVariant.soft,
///   color: NIconButtonColor.primary,
/// )
/// ```
class NIconButton extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// Called when the button is tapped.
  /// Set to `null` or set [disabled] to `true` to prevent interaction.
  final VoidCallback? onPressed;

  /// The visual style. Defaults to [NIconButtonVariant.soft].
  final NIconButtonVariant variant;

  /// The semantic color role. Defaults to [NIconButtonColor.neutral].
  final NIconButtonColor color;

  /// The size of the button. Defaults to [NIconButtonSize.md].
  final NIconButtonSize size;

  /// When `true`, the button is rendered at 50% opacity and cannot be tapped.
  final bool disabled;

  /// An optional tooltip message shown on long-press.
  final String? tooltip;

  /// Overrides the resolved icon color.
  final Color? iconColor;

  /// Overrides the resolved background color.
  final Color? backgroundColor;

  /// Overrides the resolved border color.
  final Color? borderColor;

  /// Overrides the inner padding.
  final EdgeInsetsGeometry? padding;

  /// Overrides the corner radius.
  final double? borderRadius;

  /// Creates an [NIconButton] with the default [NIconButtonSize.md] size.
  const NIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = NIconButtonVariant.soft,
    this.color = NIconButtonColor.neutral,
    this.size = NIconButtonSize.md,
    this.disabled = false,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
  });

  /// Creates a small [NIconButton].
  ///
  /// Shorthand for `NIconButton(size: NIconButtonSize.sm, ...)`.
  const NIconButton.sm({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = NIconButtonVariant.soft,
    this.color = NIconButtonColor.neutral,
    this.disabled = false,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
  }) : size = NIconButtonSize.sm;

  /// Creates a large [NIconButton].
  ///
  /// Shorthand for `NIconButton(size: NIconButtonSize.lg, ...)`.
  const NIconButton.lg({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = NIconButtonVariant.soft,
    this.color = NIconButtonColor.neutral,
    this.disabled = false,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.borderRadius,
  }) : size = NIconButtonSize.lg;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final iconSize = _getIconSize();
    final pad = padding ?? _getPadding();
    final radius = borderRadius ?? _getBorderRadius();

    final resolvedIconColor = iconColor ?? colors['foreground'];
    final resolvedBg = backgroundColor ?? colors['background'];
    final resolvedBorder = borderColor ?? colors['border'];

    final button = Material(
      color: resolvedBg,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: pad,
          decoration: BoxDecoration(
            border: resolvedBorder != null
                ? Border.all(color: resolvedBorder, width: 1)
                : null,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Semantics(
            button: true,
            enabled: !disabled,
            child: Icon(
              icon,
              color: disabled
                  ? resolvedIconColor?.withValues(alpha: 0.5)
                  : resolvedIconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  NComponentColor get _componentColor =>
      NComponentColor.values[color.index];

  Map<String, Color?> _getColors(BuildContext context) {
    final c = NComponentColors.resolve(context, _componentColor,
        neutralMain: (ctx) => NTokens.textMuted(ctx));
    final semanticColor = c.main;

    switch (variant) {
      case NIconButtonVariant.solid:
        return {
          'background': semanticColor,
          'foreground': NTokens.textInverted(context),
          'border': null
        };
      case NIconButtonVariant.soft:
        return {
          'background': semanticColor.withValues(alpha: 0.1),
          'foreground': semanticColor,
          'border': null
        };
      case NIconButtonVariant.outline:
        return {
          'background': Colors.transparent,
          'foreground': semanticColor,
          'border': semanticColor.withValues(alpha: 0.3)
        };
      case NIconButtonVariant.ghost:
        return {
          'background': Colors.transparent,
          'foreground': semanticColor,
          'border': null
        };
    }
  }

  double _getIconSize() {
    switch (size) {
      case NIconButtonSize.sm:
        return 16;
      case NIconButtonSize.md:
        return 20;
      case NIconButtonSize.lg:
        return 24;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case NIconButtonSize.sm:
        return const EdgeInsets.all(8);
      case NIconButtonSize.md:
        return const EdgeInsets.all(10);
      case NIconButtonSize.lg:
        return const EdgeInsets.all(12);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case NIconButtonSize.sm:
        return 8;
      case NIconButtonSize.md:
        return 10;
      case NIconButtonSize.lg:
        return 12;
    }
  }
}

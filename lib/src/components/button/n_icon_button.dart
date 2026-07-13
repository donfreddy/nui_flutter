import 'package:nui_flutter/nui_flutter.dart';
import 'package:flutter/material.dart';

/// The size of an [NIconButton], controlling padding, icon size, and corner radius.
enum NIconButtonSize {
  /// Small (16 dp icon, 8 dp padding).
  sm,

  /// Medium (20 dp icon, 10 dp padding). The default size.
  md,

  /// Large (24 dp icon, 12 dp padding).
  lg,
}

/// An icon-only button with five visual variants and seven semantic color roles.
///
/// Use [NIconButton.sm] or [NIconButton.lg] for convenient size shortcuts.
/// An optional [tooltip] is shown on long-press.
///
/// ```dart
/// NIconButton(
///   icon: NIcons.bell,
///   onPressed: _openNotifications,
///   variant: NVariant.soft,
///   color: NColorRole.primary,
/// )
/// ```
class NIconButton extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// Called when the button is tapped.
  /// Set to `null` or set [disabled] to `true` to prevent interaction.
  final VoidCallback? onPressed;

  /// The visual style. Defaults to [NVariant.soft].
  final NVariant variant;

  /// The semantic color role. Defaults to [NColorRole.neutral].
  final NColorRole color;

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
    this.variant = NVariant.subtle,
    this.color = NColorRole.neutral,
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
    this.variant = NVariant.soft,
    this.color = NColorRole.neutral,
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
    this.variant = NVariant.subtle,
    this.color = NColorRole.neutral,
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
    final resolved =
        NVariantResolver.resolve(color, variant, context.nui.colors);
    final iconSize = _getIconSize();
    final pad = padding ?? _getPadding();
    final radius = borderRadius ?? _getBorderRadius();

    final resolvedIconColor = iconColor ?? resolved.foreground;
    final resolvedBg = backgroundColor ?? resolved.background;
    final resolvedBorder = borderColor ?? resolved.border;
    final isDisabled = disabled || onPressed == null;

    final button = Container(
      padding: pad,
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: BorderRadius.circular(radius),
        border: resolvedBorder != null
            ? Border.all(color: resolvedBorder, width: 1)
            : null,
      ),
      child: Semantics(
        button: true,
        enabled: !isDisabled,
        child: Icon(
          icon,
          color: isDisabled
              ? resolvedIconColor.withValues(alpha: 0.5)
              : resolvedIconColor,
          size: iconSize,
        ),
      ),
    );

    final pressButton = NPressScale(
      onTap: isDisabled ? null : onPressed,
      enabled: !isDisabled,
      child: button,
    );

    final result = tooltip != null
        ? Tooltip(message: tooltip!, child: pressButton)
        : pressButton;

    return Align(child: result);
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
        return 16;
      case NIconButtonSize.md:
        return 20;
      case NIconButtonSize.lg:
        return 24;
    }
  }
}
